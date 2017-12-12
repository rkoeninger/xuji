# 续集 Xùjí

SQL for Shen

```shen
(load-sql FilePath)             \\ Reads, parses, evals file at path
(load-sql-tree RootPath)        \\ Reads, parses, sorts, evals all files in path
(read-sql String)               \\ Parses sql string into ast
(eval-sql Ast)                  \\ Evals sql ast, doing type inference and generating types and functions
*sql-schema*                    \\ Holds global database of presently loaded information about the schema
```
