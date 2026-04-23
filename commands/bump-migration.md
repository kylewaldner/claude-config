# Bump Migration Version

Find the new migration files added in the current branch (compared to main) in `libs/database/src/main/resources/database/db/migration/` and bump the version numbers to not conflict with existing migrations. Keep the relative version order consistent with the new files

Steps:
1. Run `git diff main --name-only` to find files added in this branch
2. Filter for files in `libs/database/src/main/resources/database/db/migration/`
3. Identify the new migration file (should be only one)
4. Extract the current filename pattern (e.g., `V123__description.sql`)
5. Rename the file to use the new version number while preserving the description (e.g.,
`V${arg1}__description.sql`)
6. Confirm the rename was successful
7. git stage the new files so that git recognizes the file renames
