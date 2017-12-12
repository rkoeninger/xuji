
(defcc <conditional>
  Cond := Cond;)

(defcc <selections>
  Name , <selections> := [Name | <selections>];
  Name := [Name];)

(defcc <joins>
  join Name on <conditional> <joins> := [(@p Name <conditional>) | <joins>];
  join Name on <conditional> := [(@p Name <conditional>)];)

(defcc <sources>
  Name <joins> := [Name | <joins>];
  Name := [Name];)

(defcc <target>
  Name := Name;)

(defcc <assignments>
  Column = Expr , <assignments> := [(@p Column Expr) | <assignments>];
  Column = Expr := [(@p Column Expr)];)

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

(defcc <sql>
  <select> := <select>;
  <update> := <update>;)
