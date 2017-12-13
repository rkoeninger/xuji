
\\ These are just curlies for now until the lexer can be replaced
(defcc <lparen> { := skip;)
(defcc <rparen> } := skip;)

(defcc <conditional-operator>
  = := =;
  < := <;
  > := >;
  <= := <=;
  >= := >=;
  <> := <>;)

(defcc <binary-operator>
  + := +;
  - := -;
  * := *;
  / := /;
  <conditional-operator> := <conditional-operator>;)

(defcc <expression>
  <lparen> <expression> <rparen> as Name := [as <expression> Name];
  Name1 <binary-operator> Name2 := [<binary-operator> Name1 Name2];
  Name := Name;)

(defcc <conditional>
  <lparen> <conditional1> <rparen> and <lparen> <conditional2> <rparen> := [and <conditional1> <conditional2>];
  <lparen> <conditional1> <rparen> or  <lparen> <conditional2> <rparen> := [or  <conditional1> <conditional2>];
  Name1 <conditional-operator> Name2 := [<conditional-operator> Name1 Name2];)

(defcc <conditional1> <conditional> := <conditional>;)
(defcc <conditional2> <conditional> := <conditional>;)

(defcc <selections>
  <expression> , <selections> := [<expression> | <selections>];
  <expression> := [<expression>];)

(defcc <joins>
  join Name on <conditional> <joins> := [(@p Name <conditional>) | <joins>];
  join Name on <conditional> := [(@p Name <conditional>)];)

(defcc <sources>
  Name <joins> := [Name | <joins>];
  Name := [Name];)

(defcc <target>
  Name := Name;)

(defcc <assignments>
  Column = <expression> , <assignments> := [(@p Column <expression>) | <assignments>];
  Column = <expression> := [(@p Column <expression>)];)

(defcc <columns>
  <rparen> := skip;
  Name , <columns> := [Name | <columns>];
  Name := [Name];)

(defcc <values>
  <rparen> := skip;
  <expression> , <values> := [<expression> | <values>];
  <expression> := [<expression>])

(defcc <column-declarations>
  <rparen> := skip;
  Name Type , <column-declarations> := [(@p Name Type) | <column-declarations>];
  Name Type := [(@p Name Type)];)

(defcc <select>

  select <selections>
  from <sources>
  where <conditional>

  := [select
      [selections <selections>]
      [sources <sources>]
      [conditional <conditional>]];

  select <selections>
  from <sources>

  := [select
      [selections <selections>]
      [sources <sources>]];

  select <selections>

  := [select [selections <selections>]];)

(defcc <update>

  update <target>
  set <assignments>
  where <conditional>

  := [update
      [target <target>]
      [assignments <assignments>]
      [conditional <conditional>]];)

(defcc <insert>

  insert into <target> <lparen> <columns> <rparen>
  values <lparen> <values> <rparen>

  := [insert
      [target <target>]
      [columns <columns>]
      [values <values>]];)

(defcc <delete>

  delete from <target>
  where <conditional>

  := [delete
      [target <target>]
      [conditional <conditional>]];)

(defcc <create-table>

  create table Name <lparen> <column-declarations> <rparen>

  := [create
      [name Name]
      [columns <column-declarations>]];)

(defcc <sql>
  <select> := <select>;
  <update> := <update>;
  <insert> := <insert>;
  <delete> := <delete>;
  <create-table> := <create-table>;)

(define parse-sql
  Ast -> (compile (function <sql>) Ast))

(define parse-sql-from-string
  String -> (parse-sql (read-from-string String)))
