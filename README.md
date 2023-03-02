# 7330_final_project

Instructions after loading the repository & creating a new project:

	1. Go to Libraries.R & make sure all the packages are installed.

	2. Go to secrets_guide.R & copy the code to a new file in R. Replace the password value with the password you use to sign into your 'root' directory in MySQL, & make sure your password is in quotes. Name this new version of the code secrets.R. If you don't do this exactly, NOTHING will work.

	3. Go to Connections/Local_connect.R & make sure you can connect. If you cannot, your secrets are wrong.

	4. Go to Main_Task.R, & run the program completely through (ctrl + a -> ctrl + enter). It should work completely. (Note: it will take 36 - 74 minutes to just load in the data not including schema & table creation & normalization)

	5. If there is an error, it will be in Data_load.R. If it does throw an error, a couple of things will happen. The schema associated with the current season/year that is being loaded will have all its tables truncated, so the tables for the schema will still exist, but they will have no data/be empty. Also, a table with one row will pop up. This is the table_insert_tracker, & the row that is being shown is for the season/year that failed. The first 0 is where the data load failed. It also lists the current round it was trying to insert. If it fails anywhere besides API, let me know. If it fails at API, the API likely timed out. Then rerun the code from the top of Data_load.R

	6. Don't update any of the code dealing with the data loading process because it'll wreck havok on your computer when it comes to pushing & pulling code. Let me (Michael) know if there is an error, & I'll fix it ASAP. Also, let me know what section you're working on, so I can create a folder for it. Feel free to update the contents in that folder as much as you'd like.
