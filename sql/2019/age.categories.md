# BHAA Age Categories

At the moment, the BHAA results don't really cater for good 'age_category' or 'prize winner' reporting

- https://bhaa.ie/race/irish-life-6km-2018/

## Ideally

I want to 'borrow' ideas from this site which has better result layouts

- https://results.nyrr.org/event/18TC15/runnerAwards

Drill down to each runner to see the runners position within the gender, and specific age category.

I'd like the BHAA schema to support the different age category results in a some what sustainable way.

## Currently

This is the current structure 

### wp_bhaa_agecategory

We have the 'wp_bhaa_agecategory' table which defined as

    CREATE TABLE IF NOT EXISTS wp_bhaa_agecategory (
    category varchar(2) DEFAULT NOT NULL,
    gender enum('M','W') DEFAULT 'M',
    min int(11) NOT NULL,
    max int(11) NOT NULL,
    PRIMARY KEY (category)
    
the data in the table currently just the age-ranges
   
    S	M	18	34
    M35	M	35	39
    M40	M	40	44
    
and it'a not referenced within SQL queries. Its a bit shit really.

### wp_bhaa_raceresult

The 'wp_bhaa_raceresult' table looks like

    create table wp_bhaa_raceresult
    (
    id int auto_increment
    primary key,
    race int not null,
    runner int not null,
    racetime time null,
    position int null,
    racenumber int null,
    category varchar(6) null,
    standard int null,
    actualstandard int null,
    poststandard int null,
    pace time null,
    posincat int null,
    posinstd int null,
    standardscoringset int null,
    posinsss int null,
    leaguepoints double null,
    class varchar(10) null,
    company int null
    )    

Note the 'category' is not FK'd to the wp_bhaa_agecategory table, and there is a stored procedure to update the 'posincat' column.

We effectively take the age-category details from the race results and don;t have any logic to calculate this stuff dynamically
    
## Issues

List of issues that the new schema design should address

###  Top Three

How to track the top three runners by gender for each race?
- We know the simple case, the top 3 are all senior men/women, etc and repeat down the line.
- More complex case, all top three runners are members of the higher age categories. 
- M50 wins, W40 comes second, M35 male comes 3rd overall, 4th M35.
    - M50 appears first overall. The 2nd M50 wins the category prize.
    - M35 appears in overall winners row (with position 2nd in gender)
    - The 2nd V35 appears 1st in M35 age group (no prize). He's 3rd in gender group, 2nd in age category grouping.
- We need the awards to show the correct age category prizes (see madness below)

### M35 Runners

M35 runners don't get age category prizes. 

### Configure Prizes Per Category

For higher V70/V80 there are only two prizes

#### Current Thoughts

I'm thinking add a 'prizes' count column to the table

    CREATE TABLE IF NOT EXISTS wp_bhaa_agecategory (
    category varchar(2) DEFAULT NOT NULL,
    gender enum('M','W') DEFAULT 'M',
    min int(11) NOT NULL,
    max int(11) NOT NULL,
    prizes int(11) NOT NULL,
    PRIMARY KEY (category)
    
the data in the table will now have gender specific rows and a prize count per row
   
    M	M	18	34 3
    W	W	18	34 3
    M35	M	35	39 0
    W35	W	35	39 3
    M40	M	40	44 3
    W40	W	40	44 3
    M80	M	80	99 2
    W80	W	80	99 2

The awards layout reporting can group by (gender,min) to ensure the two rows of M35 and W35 are presented on the same row. 
The awards layout reporting can use the 'prize' = 0 to indicate that no prize is awarded.
  
I don't like that there is a lot of duplication of data across the rows on this table. Perhaps this table could be split out
to 'age_grade' and then a second table which handles the awarding of prixes.

I think we need to record the top three in each gender somewhere, the options i see are

* Add a new table 'wp_bhaa_racetopthree' which holds the race and 6 rows of runner id's?
* Add a more generic 'wp_bhaa_raceawards' table which just tracks all category winners?
* If we foreign key the 'category' column for each 'wp_bhaa_raceresult' row.
    * Do we just add extra columns with this table.
    * All runners will be in a 'gender' and 'category' position.
    * For most runners, they are not he top three this is reduntant.
    
For the three options above the question in my head is around calculating and recording the position in 'gender' and 'agecagtegory' once 
when we process results, against having to dynamically recalculate these results each time a race page is rendered and complexity of GROUP BY logic in the specific SQL queries.
