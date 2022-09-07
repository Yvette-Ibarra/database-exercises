#1. Create a new file called select_exercises.sql. Store your code for this exercise in that file. You should be testing your code in MySQL Workbench as you go.
#2 Use the albums_db database.
USE albums_db;
#3 Explore the structure of the albums table.
SELECT *
FROM albums;
	#a. How many rows are in the albums table?  There are 31 rows.
    
	#b. How many unique artist names are in the albums table? There are unique artist names 23.
SELECT count(distinct artist)
FROM albums;
    
	#c. What is the primary key for the albums table? The primary key is 'id' for the albums table.
SELECT id
FROM albums;
	/*d. What is the oldest release date for any album in the albums table? What is the most recent release date? 
   The oldest album is 'The Beatles', 'Sgt. Pepper\'s Lonely Hearts Club Band', '1967'
   The most recent album is 'Adele', '21', '2011'*/


SELECT artist,name,release_date
FROM albums
Order by release_date;

#4 Write queries to find the following information:
#a. The name of all albums by Pink Floyd. The name of all albums is 'The Dark Side of the Moon' and 'The Wall'
SELECT name, artist
FROM albums
WHERE artist = 'Pink Floyd';
#b. The year Sgt. Pepper's Lonely Hearts Club Band was released in 1967
SELECT release_date,name, artist
FROM albums
WHERE name ='Sgt. Pepper\'s Lonely Hearts Club Band';
#c. The genre for the album Nevermind. The genre for the album Nevermind is 'Grunge, Alternative rock'
SELECT genre
FROM albums
WHERE name = 'Nevermind';

/*d. Which albums were released in the 1990s
# name	release_date
The Bodyguard	1992
Jagged Little Pill	1995
Come On Over	1997
Falling into You	1996
Let's Talk About Love	1997
Dangerous	1991
The Immaculate Collection	1990
Titanic: Music from the Motion Picture	1997
Metallica	1991
Nevermind	1991
Supernatural	1999 */

SELECT name, release_date
FROM albums
WHERE release_date BETWEEN 1990 AND 1999;


#e. Which albums had less than 20 million certified sales
SELECT name, sales
FROM albums
WHERE sales< 20;

/*f. All the albums with a genre of "Rock". Why do these query results not include albums with a genre of "Hard rock" or "Progressive rock"?
 We only see the genre "Rock" because our genre in whrere has an = sign which means to look for exact match. Other genres
 have the work "rock' in them such as "Progressive rock" but the characters are not an exact match*/
SELECT name, genre
FROM albums
WHERE genre = 'Rock';

#5 Be sure to add, commit, and push your work.