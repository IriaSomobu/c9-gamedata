FIND_PACKAGE(Gettext)

IF (NOT GETTEXT_FOUND)
    MESSAGE(FATAL_ERROR "Gettext not found! Unable to setup localization properly. Aboring build")
ENDIF (NOT GETTEXT_FOUND)

# Extract json strings
add_custom_target (
    extract_string
    COMMAND python3 gamedata/lang/extract_json_strings.py
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

# Generate cataclysm-nine.pot
# Note: there are also was `${CMAKE_SOURCE_DIR}/gamedata/lang/json/*.py'` parameter, but Somobu
# removed it because it caused translations compilation error.
add_custom_target (
    translations
    COMMAND xgettext --default-domain="cataclysm-dda"
                     --sort-by-file
                     --add-comments="~"
                     --output="${CMAKE_SOURCE_DIR}/gamedata/lang/po/cataclysm-nine.pot"
                     --keyword="_"
                     --keyword="pgettext:1c,2"
                     --keyword="ngettext:1,2"
                     --from-code="UTF-8"
                     ${CMAKE_SOURCE_DIR}/src/*/*.cpp
                     ${CMAKE_SOURCE_DIR}/src/*/*.h
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS extract_string
)

add_custom_target (
    translations_prepare
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS translations
)


# Auto-Compile translation on release builds only
IF (RELEASE)
    add_custom_target (
        translations_compile
        ALL
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        DEPENDS translations_prepare
    )
ELSE (RELEASE)
    add_custom_target (
        translations_compile
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        DEPENDS translations_prepare
    )
ENDIF (RELEASE)


# Compile .po files of selected languages into .mo files
foreach (LANG ${LANGUAGES})
    add_custom_command (
      TARGET translations_prepare
      PRE_BUILD
      COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/gamedata/lang/mo/${LANG}/LC_MESSAGES
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    IF (${LANG} STREQUAL en)
      # English is special: we do not actually need translation for English, but
      # due to a libintl bug (https://savannah.gnu.org/bugs/index.php?58006),
      # gettext would be extremely slow on MinGW targets if we do not compile a
      # .mo file.
      add_custom_command (
        TARGET translations_prepare
        PRE_BUILD
        COMMAND msgen ${CMAKE_SOURCE_DIR}/gamedata/lang/po/cataclysm-nine.pot --output-file=${CMAKE_SOURCE_DIR}/gamedata/lang/po/en.po
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      )
    ENDIF (${LANG} STREQUAL en)

    add_custom_command (
      TARGET translations_compile
      PRE_BUILD
      COMMAND 
      ${GETTEXT_MSGFMT_EXECUTABLE} -f ${CMAKE_SOURCE_DIR}/gamedata/lang/po/${LANG}.po
             -o ${CMAKE_SOURCE_DIR}/gamedata/lang/mo/${LANG}/LC_MESSAGES/cataclysm-nine.mo
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

endforeach()

