/*
drop table school.CourseAndStudent
drop table school.CourseAndTeacher
drop table school.classroomandcourses
drop table school.course
drop table school.classroom 
drop table school.room_style 
drop table school.Learn_Objective 
drop table school.student_phone 
drop table school.student 
drop table school.Teacher_phone 
drop table school.Teacher 

*/
use _SandBox 
--GO

select [name] SchemaName  from sys.schemas where [name] = 'school' ; 
--GO

create table School.Classroom (
	Classroom_Key			 smallint not null identity(1,1) ,
	Classroom_CampusBuilding smallint not null ,   --  table of campuses
	Classroom_Number		 varchar(32) not null,  -- in case the classroooms are alpha numeric
	Classroom_Capacity		 smallint not null default 12, 
	Classroom_Style          char(1) not null  default 'U' ,   -- school.Room_Style table 
	Classroom_Created        datetime not null default getdate() ,
	Classroom_Updated        datetime not null default getdate() ,
	constraint PK_Classroom_Key primary key (Classroom_Key) 
) 
--GO

create table School.Course (
	Course_Key				smallint	not null identity(1,1)  ,
	Course_Name				varchar(64) not null default 'Undefined' , 
	Course_Department       smallint	not null,  -- department tble 
	Course_Number			varchar(32) not null default 'A-000',  -- incase of alpha numeric 
	Course_Objective		char(2)		not	null default 'U'    ,  --  'U' for unknown in learn_objective table 
	Course_Created          datetime	not null default getdate() ,
	Course_Updated          datetime	not null default getdate() ,
	constraint PK_Course_Key primary key (Course_Key) 
) 
--GO

create table School.ClassroomAndCourses (
	ClassroomAndCourses_Key	smallint not null identity(1,1) , 
	FK_Classroom			smallint not null ,
	FK_Course				smallint not null ,
	constraint PK_ClassroomAndCourses_Key primary key (ClassroomAndCourses_Key) 
) 
--GO


create table school.Room_Style (
	RoomStyle_Key			smallint not null identity(1,1) , 
	RoomStyle_Code			char(1) not null  ,   -- U for unknown
	RoomStyle_Desc			nvarchar(64) not null ,
	RoomStyle_Created		datetime not null default getdate() , 
	RoomStyle_Updated		datetime not null default getdate() ,
	constraint PK_RoomStyle_Key primary key (RoomStyle_Code) 
) 
--GO

CREATE UNIQUE NONCLUSTERED INDEX Idx_NCU_RoomStyleCode ON [School].[Room_Style]
([RoomStyle_Key] ASC)

--GO

create table school.Learn_Objective (
	LearnObjective_Key		smallint not null identity(1,1) , 
	LearnObjective_Code		char(2)  not null  ,   -- 'U' for unknown
	LearnObjective_Desc		char(64) not null , 
	LearnObjective_Created	datetime not null default getdate() , 
	LearnObjective_Updated	datetime not null default getdate() ,
	constraint PK_LearnObjective_Key primary key (LearnObjective_Code) 
) 
--GO

CREATE UNIQUE NONCLUSTERED INDEX Idx_NCU_LearnObjectiveCode ON [School].[Learn_Objective]
([LearnObjective_Key] ASC)

--GO

alter table school.ClassroomAndCourses
add constraint FK_Classroom foreign key (FK_Classroom) references school.classroom(classroom_Key) on update no action on delete no action; 
--GO

alter table school.ClassroomAndCourses
add constraint FK_Course foreign key (FK_Course) references school.course(course_Key) on update no action on delete no action; 
--GO

alter table School.Classroom
add constraint FK_ClassRoomStyle foreign key (Classroom_Style) references School.Room_Style(RoomStyle_Code) on update no action on delete no action; 
--GO

alter table school.course
add constraint FK_CourseObjective foreign key (Course_Objective) references school.Learn_Objective(LearnObjective_code) on update no action on delete no action;
--GO

--==========================================
create table school.Student (
	Student_Key		smallint not null identity(1,1) ,
	Student_ID		char(8) not null , -- constraint dflt_ID default ('00-00000'), 
	Student_FName   nvarchar(32) not null  ,
	Student_LName   nvarchar(32) not null  ,
	Student_eMails  smallint null Constraint dflt_emails  default 0, 
	Student_Mailing smallint null Constraint dflt_mailing default 0,
	Student_SSN4    smallint null Constraint dflt_SSN4    default 0,
	Student_Created datetime not null constraint dflt_created default getdate(),
	Student_Updated datetime not null constraint dflt_updated default getdate(),
	constraint PK_Student_ID     primary key (Student_ID) 
	) ; 
--GO
--==========================================
create table school.student_phone(
	Phone_Key			smallint not null identity(1,1) , 
	Phone_Student_ID	char(8) not null ,
	Phone_Number	    varchar(20) not null constraint DFLT_PhoneNumber default ('000-000-0000') ,
	Phone_Type	        char(1) not null constraint DFLT_PhoneType default ('C') ,
	Phone_Created		datetime not null constraint DFLT_phone_Created  default getdate() , 
	Phone_UPdated		datetime not null constraint DFLT_phone_Updated  default getdate() , 
	Constraint PK_Phone_Key primary key (Phone_key) ,
	constraint FK_Student_ID foreign key (phone_Student_ID) references school.student(student_id) 
) 
--GO
create unique nonclustered index Idx_PhoneStudentID on school.student_phone (phone_student_id  asc)  ; 
--GO

--==========================================
--==========================================
create table school.Teacher (
	Teacher_Key		smallint not null identity(1,1) ,
	Teacher_ID		char(8) not null , -- constraint dflt_ID default ('00-00000'), 
	Teacher_FName   nvarchar(32) not null  ,
	Teacher_LName   nvarchar(32) not null  ,
	Teacher_eMails  smallint null Constraint dflt_Teacher_emails  default 0, 
	Teacher_Mailing smallint null Constraint dflt_Teacher_mailing default 0,
	Teacher_SSN4    smallint null Constraint dflt_Teacher_SSN4    default 0,
	Teacher_Created datetime not null constraint dflt_Teacher_created default getdate(),
	Teacher_Updated datetime not null constraint dflt_Teacher_updated default getdate(),
	constraint PK_Teacher_ID     primary key (Teacher_ID) 
	) ; 
--GO
--==========================================
create table school.Teacher_phone(
	Phone_Key			smallint not null identity(1,1) , 
	Phone_Teacher_ID	char(8) not null ,
	Phone_Number	    varchar(20) not null constraint DFLT_Teacher_PhoneNumber default ('000-000-0000') ,
	Phone_Type	        char(1) not null constraint DFLT_Teacher_PhoneType default ('C') ,
	Phone_Created		datetime not null constraint DFLT_Teacher_phone_Created  default getdate() , 
	Phone_UPdated		datetime not null constraint DFLT_Teacher_phone_Updated  default getdate() , 
	Constraint PK_Teacher_Phone_Key primary key (Phone_key) ,
	constraint FK_Teacher_ID foreign key (phone_Teacher_ID) references school.Teacher(Teacher_id) 
) 
--GO
create unique nonclustered index Idx_PhoneTeacherID on school.Teacher_phone (phone_Teacher_id  asc)  ; 
--GO

--==========================================
create table School.CourseAndStudent (
	CourseAndStudent_Key	smallint not null identity(1,1) , 
	FK_Student_C	char(8) not null ,
	FK_Course_S		smallint not null ,
	constraint PK_CourseAndStudent_Key primary key (CourseAndStudent_Key) ,
	constraint FK_Student_C foreign key (FK_Student_C) references school.student(student_ID) ,
	constraint FK_Course_S  foreign key (FK_Course_S)  references school.course (course_key) 
) 
--GO

--==========================================
create table School.CourseAndTeacher (
	CourseAndTeacher_Key	smallint not null identity(1,1) , 
	FK_Teacher_C			char(8) not null ,
	FK_Course_T				smallint not null ,
	constraint PK_CourseAndTeacher_Key primary key (CourseAndTeacher_Key) ,
	constraint FK_Teacher_C foreign key(FK_Teacher_C) references school.Teacher(teacher_Id) ,
	constraint FK_Course_T  foreign key(FK_Course_T)  references school.course(course_Key) 
) 
--GO

--==========================================

create table school.Academic_Department (
	Dept_Key		smallint not null identity(1,1) , 
	Dept_Code		char(4) not null constraint PK_Dept primary key , 
	Dept_Desc		nvarchar(64) not null constraint DFLT_Dept_Desc default '0000' ,
	Dept_Created    datetime constraint DFLT_Dept_Created default getdate() ,
	Dept_Updated    datetime constraint DFLT_Dept_Updated default getdate() 
	);
--GO

--==========================================
create table School.DeptAndStudent (
	DeptAndStudent_Key	smallint not null identity(1,1) , 
	FK_Student_D	char(8) not null ,
	FK_Dept_S		char(4) not null ,
	constraint PK_DeptAndStudent_Key primary key (DeptAndStudent_Key) ,
	constraint FK_Student_D foreign key (FK_Student_D) references school.student(student_ID) ,
	constraint FK_Dept_S    foreign key (FK_Dept_S)    references school.Academic_Department (Dept_Code) 
) 
--GO

--==========================================
create table School.DeptAndTeacher (
	DeptAndTeacher_Key	smallint not null identity(1,1) , 
	FK_Teacher_D			char(8) not null ,
	FK_Dept_T				char(4) not null ,
	constraint PK_DeptAndTeacher_Key primary key (DeptAndTeacher_Key) ,
	constraint FK_Teacher_D foreign key(FK_Teacher_D) references school.Teacher(teacher_Id) ,
	constraint FK_Dept_T  foreign key(FK_Dept_T)  references school.Academic_Department(Dept_Code) 
) 
--GO