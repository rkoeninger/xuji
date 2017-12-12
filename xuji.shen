
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
  ( <expression> ) as Name := [as <expression> Name];
  Name1 <binary-operator> Name2 := [<binary-operator> Name1 Name2];
  Name := Name;)

(defcc <conditional>
  ( <conditional1> ) and ( <conditional2> ) := [and <conditional1> <conditional2>];
  ( <conditional1> ) or  ( <conditional2> ) := [or  <conditional1> <conditional2>];
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

  insert into <target> ( <columns> )
  values ( <values> )

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

(defcc <sql>
  <select> := <select>;
  <update> := <update>;
  <insert> := <insert>;
  <delete> := <delete>;)

(define parse-sql
  Ast -> (compile (function <sql>) Ast))

(define parse-sql-from-string
  String -> (parse-sql (read-from-string String)))
