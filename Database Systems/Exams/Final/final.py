# python3 -m pip install mysql-connector-python
import mysql.connector

# establish connection to database as user "api"
try:
    mydb = mysql.connector.connect(
    host="localhost",
    user="api",
    password="password",
    database="CSC315Final2024"
    )
except:
    print("Error: Unable to connect to database.")
    exit(1)

# create cursor object
mycursor = mydb.cursor()

mydb.commit()

def getError(error, result): 
    return(error, result) 

def queryExecute(query, *args): 
    try:
        mycursor.execute(query)
    except mysql.connector.Error as err: 
        return getError(True, err) 

    return getError(False, [*mycursor])


#  10. queries from tasks 4-8

# Create a query to determine which sub_genres come from which regions
def subGenreRegion():
    query = '''SELECT DISTINCT S.sgname, R.rname FROM Band_Styles S JOIN
    (SELECT O.bname, N.rname FROM Band_Origins O JOIN Nation N
        WHERE N.cname = O.cname
    ) AS R
    WHERE S.bname = R.bname;'''
    return queryExecute(query)

# Create a query to determine what other bands, not currently in their favorites, 
# are of the same sub_genres as those which are
def otherBands(userid):
    query = '''SELECT bname FROM
(SELECT DISTINCT sgname FROM 
    (SELECT bname FROM Bands WHERE bid IN 
        (SELECT bid FROM Favorites WHERE uid=%s)
    ) AS UsersFavorites
    JOIN
    (SELECT bname,sgname FROM Band_Styles) AS Styles 
    WHERE UsersFavorites.bname = Styles.bname) AS SGUsersFavorites
JOIN
(SELECT DISTINCT NotFavorites.bname,sgname FROM 
    (SELECT bid,bname FROM Bands WHERE bid NOT IN 
        (SELECT bid FROM Favorites WHERE uid=%s)
    ) as NotFavorites
    JOIN
    (SELECT bname,sgname FROM Band_Styles) AS Styles 
    WHERE NotFavorites.bname = Styles.bname) AS SGNotUsersFavorites
WHERE SGNotUsersFavorites.sgname = SGUsersFavorites.sgname;'''
    return queryExecute(query,userid, userid)

# Create a query to determine what other bands, not currently in their favorites, 
# are of the same genres as those which are.
def otherBandsGenre(userid):
    query = '''SELECT DISTINCT GNotUsersFavorites.bname,GNotUsersFavorites.gname FROM

    (SELECT DISTINCT UsersFavorites.bname,BGenre.gname FROM 
        (SELECT bname FROM Bands WHERE bid IN 
            (SELECT bid FROM Favorites WHERE uid=%s)
        ) AS UsersFavorites
        JOIN
        (SELECT Style.bname,Style.sgname,SGenre.gname FROM
            Band_Styles Style JOIN Sub_Genre SGenre 
                WHERE Style.sgname=SGenre.sgname
            ) AS BGenre
    WHERE UsersFavorites.bname=BGenre.bname) AS GUsersFavorites
    JOIN
    (SELECT DISTINCT NotUsersFavorites.bname,BGenre.gname FROM 
        (SELECT bname FROM Bands WHERE bid NOT IN
            (SELECT bid FROM Favorites WHERE uid=%s)
        ) AS NotUsersFavorites
        JOIN
        (SELECT Style.bname,Style.sgname,SGenre.gname FROM 
            Band_Styles Style JOIN Sub_Genre SGenre 
                WHERE Style.sgname=SGenre.sgname
            ) AS BGenre
    WHERE NotUsersFavorites.bname=BGenre.bname) AS GNotUsersFavorites

WHERE GNotUsersFavorites.gname=GUsersFavorites.gname;'''
    return queryExecute(query,userid, userid)

# Query 7 Create a query which finds other users who have the same band in their favorites, 
# and list their other favorite bands.
def otherUsers(userid):
    query = '''SELECT bname FROM Bands JOIN
    (SELECT DISTINCT bid FROM
        (SELECT uid FROM Favorites WHERE bid IN 
            (SELECT bid FROM Favorites WHERE uid=%s)
                AND uid!=%s) AS OtherUsers
        JOIN
        (select * from Favorites) AS F
    WHERE F.uid=OtherUsers.uid) AS OtherFavorites
WHERE Bands.bid=OtherFavorites.bid;'''
    return queryExecute(query, userid, userid)

# Create a query to list other countries, excluding the user’s home country, 
# where they could travel to where they could hear the same genres as the bands 
# in their favorites.
def countries(userid):
    query = '''SELECT DISTINCT cname FROM Band_Origins
JOIN
    (SELECT DISTINCT BGenre.* FROM 
        (SELECT bname FROM Bands WHERE bid IN
            (SELECT bid FROM Favorites WHERE uid=%s)
        ) AS UsersFavorites
        JOIN
        (SELECT Style.bname,Style.sgname,SGenre.gname FROM  
            Band_Styles Style JOIN Sub_Genre SGenre 
                where Style.sgname=SGenre.sgname
            ) AS BGenre
    WHERE UsersFavorites.bname=BGenre.bname) AS UserGenres
WHERE Band_Origins.bname=UserGenres.bname AND
cname NOT IN (SELECT homeCountry FROM Users WHERE uid=%s);'''
    return queryExecute(query, userid, userid)



# 11 - create 3 functions:

# insert a new user into the database

def newUser(name, nation): 
    query = "INSERT INTO Users(username, homeCountry) VALUES (%s, %s);"
    values = (name, nation)
    mycursor.execute(query, values)
    mydb.commit()


# check if band exists in the database and obtain bid
def addFavorite(userid, bandname):
    result = queryExecute("SELECT bname FROM Bands WHERE bname={};".format(bandname))
    bandexists = len(result) > 0

    if not bandexists:
        return getError(True, "Band does not exist")

    bandid = queryExecute("SELECT bid FROM Bands WHERE bname={};".format(bandname))

    query = "INSERT INTO Favorites (uid, bid) VALUES ({}, {});".format(userid, bandid)

    return queryExecute(query) # execute query


# delete a favorite from the database

def deleteFavorite(userid, bandname):
    result = queryExecute("SELECT bname FROM Bands WHERE name = %s;", bandname)
    bandexists = len(result) > 0

    if not bandexists:
        return getError(True, "Band does not exist")

    bandid = queryExecute("SELECT bid FROM Bands WHERE name = %s;", bandname)

    query = "DELETE FROM Favorites WHERE userid = %s AND bandid = %s;" # query to delete favorite
    return queryExecute(query, userid, bandid) # execute query


# inserting users to the database 

newUser('John One', 'United States')
newUser("John Two", "United States") 
newUser("John Three", "United States")


# inserting favorites to the database

# John Favorite
addFavorite("1", "Twisted Sister")
addFavorite("1", "Led Zeppelin")
addFavorite("1", "The Guess Who")
addFavorite("1", "Muddy Waters")

# John Two favorite  
addFavorite("2", "Led Zeppelin")
addFavorite("2", "The Guess Who")
addFavorite("2", "Muddy Waters")
addFavorite("2", "Seputura")

# John Three favorite 
addFavorite("3", "Mozart")
addFavorite("3", "Tchaikovsky")
addFavorite("3", "Twisted Sister")
addFavorite("3", "Tenger Cavalry")



# close connection if still open
if mydb:
    mydb.commit() # commit changes to the database
    mydb.close() # close the connection to the database
    # print success message
    print("\nSuccessfully closed connection to database and changes have been saved.")
else:
    print("\nSomething went wrong, changes weren't saved")
