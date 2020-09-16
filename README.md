# University-Safety-Managment-System
Background
A university safety department helps maintain law and order on the campus and helps keep the community safe. 
One of the most tedious tasks for any police department is maintaining records and reports of various incidents which requires a lot of time and effort. 
Our aim was to build a centralized database for the University Safety Department which helps them accomplish this task easily 
and put in more effort towards proactively patrolling and making the community safer. 

Overview
We worked on this project alongside the University PD, where we gathered data by interacting with the staff and understanding their needs and requirements.
We made good use of the Subtype-Supertype Entities for Employee -  Student, Civilian and Officer. Multiple triggers were also implemented for smooth insertion and manipulation of data.
The most important entity, Incident was designed such that it would keep track of the time, location and also the details of the officer incharge, which would make it easier to retrieve for future use.

DATA
The tables were populated with random data, given the reluctance of the staff to allow us data. So, we manually filled the tables using our own made up data, which serves the purpose of demonstrating the smooth functionality of the Database.

Overall, with the implementation of some views, triggers and aggregators, we were able to achieve our target of an easy to manage Database.


Running the files (SQL Server)
To run the project, first run Creation_Sripts, followed by the Insertion_Scripts in SQL Server.
The ER diagram has been included to provide a broader view of the database.
