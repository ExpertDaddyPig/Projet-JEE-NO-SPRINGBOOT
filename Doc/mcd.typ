#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 5mm, fill: white)
#set text(size: 11pt)
#set table(
   stroke: 0pt,
   columns: (auto, auto),
   align: (right, left),
)

#let frame_divide(stroke) = (x, y) => (
  left: 0pt,
  right: 0pt,
  top: if y == 1 { stroke } else { 0pt },
  bottom: 0pt,
)

#let blob(pos, heading, content, tint: blue, ..args) = node(
	pos,
   table(
      columns: (auto),
      align: center,
      inset: 10pt,
      stroke: frame_divide(1pt + black ),
      table.header(text(heading, size: 16pt, weight: "bold")),
      align(center, content),
   ),
	width: auto,
	fill: tint.lighten(70%),
	stroke: 1pt + tint.darken(20%),
	corner-radius: 5pt,
   shape: rect,
	..args,
)

#let arrow(bend, type, content-start, content-end, ..args) = {
   edge(
      bend,
      type,
      content-start,
      label-pos: 10pt,
      ..args,
   )
   edge(
      bend,
      type,
      content-end,
      label-pos: 100% - 10pt,
      ..args,
   )
}

#diagram(
	spacing: 40pt,
	edge-stroke: 1pt,
	edge-corner-radius: 5pt,
	mark-scale: 70%,

	blob((0,0),
   [
      Departements
   ], [
      #table(
         [*id:*], [int, not null, auto_increment, *pk*],
         [departement_name:], [char(50)],
         [employees:], [char(1000)],
      )
   ],),

	arrow("d,r", "<|-", [1:N], [1:1]),

	blob((1,1),
   [
      Employees
   ],
   [
      #table(
         [*id:*], [int, not null, auto_increment, *pk*],
         [*departement_id:*], [int, *fk* $-->$ Departements.id],
         [first_name:], [char(50)],
         [last_name:], [char(50)],
         [gender:], [char(50)],
         [registration_number:], [char(10)],
         [projects:], [char(1000)],
         [job_name:], [char(100)],
         [employe_rank:], [int(1 or 2 or 3 or 4)],
         [age:], [int],
         [email:], [char(100), not null, unique],
         [username:], [char(50), not null, unique],
         [password_hash:], [char(255), not null],
         [createdat:], [date],
         [lastlogin:], [date],
         [isactive:], [boolean],
      )
   ],),

	arrow("r,u", "<|-", [0:N], [1:1]),

	blob((2,0),
   [
      Payslips
   ],
   [
      #table(
         [*id:*], [int, not null, auto_increment, *pk*],
         [*employe_id:*], [int, *fk* $-->$ Employees.id],
         [month:], [int],
         [salary:], [int],
         [primes:], [int],
         [deductions:], [int],
      )
   ],),

	blob((1,2),
   [
      Link-Employees-Projects
   ],
   [
      #table(
         [*id:*], [int, not null, auto_increment, *pk*],
         [*employe_id:*], [int, *fk* $-->$ Employees.id],
         [*project_id:*], [int, *fk* $-->$ Projects.id],
      )
   ],),

   arrow("u", "-|>", [1:1], [0:N]),
   arrow("d", "-|>", [1:1], [1:N]),

	blob((1,3),
   [
      Projects
   ],
   [
      #table(
         [*id:*], [int, not null, auto_increment, *pk*],
         [project_name:], [char(50)],
         [project_state:], [char(50)['in process' or 'finished' or 'canceled'], not null],
         [employees:], [char(1000)],
      )
   ],),

)




