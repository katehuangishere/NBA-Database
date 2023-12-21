-- 1.Retrieve all columns from the Team table.
SELECT * FROM Team;

-- 2.Display unique seasons from the Season_Year table.
SELECT DISTINCT Year FROM Season_Year;

-- 3.List all players from Regular_Season_Player_Stats for the year 2008-09.
SELECT * FROM Regular_Season_Player_Stats WHERE Year = '2008-09';

-- 4.Show the top 10 players with the most points scored in the regular season.
SELECT Player, PointsScored
FROM Regular_Season_Player_Stats
WHERE Year = '2008-09'
ORDER BY PointsScored DESC
LIMIT 10;

-- 5.Retrieve the total number of teams.
SELECT COUNT(*) AS TotalTeams FROM Team;

-- 6.Find players who have played in both regular season and playoffs.
SELECT DISTINCT Player
FROM Regular_Season_Player_Stats
WHERE Year = '2008-09'
AND EXISTS (
   SELECT 1
   FROM Playoffs_Player_Stats
   WHERE PlayerID = Regular_Season_Player_Stats.PlayerID
);

-- 7.Display the average efficiency for each team in the regular season.
SELECT Team.Team, ROUND(AVG(Efficiency), 2) AS AvgEfficiency
FROM Regular_Season_Player_Stats
JOIN Team ON Regular_Season_Player_Stats.TeamID = Team.TeamID
WHERE Regular_Season_Player_Stats.Year = '2008-09'
GROUP BY Team.Team;

-- 8.List all players who made at least one three-point shot in the regular season.
SELECT DISTINCT Player
FROM Regular_Season_Player_Stats
WHERE Year = '2008-09' AND ThreePtFGMade > 0;

-- 9.Show the total number of points scored in the regular season.
SELECT SUM(PointsScored) AS TotalPoints
FROM Regular_Season_Player_Stats
WHERE Year = '2008-09';

-- 10.Retrieve players with a shooting percentage above 50% in the regular season.
SELECT Player, FGPercent
FROM Regular_Season_Player_Stats
WHERE Year = '2008-09' AND FGPercent > 0.5;

-- 11.Display the total number of games played by each team in the regular season.
SELECT Team.Team, SUM(GamesPlayed) AS Total_Games_Played
FROM Regular_Season_Player_Stats
JOIN Team ON Regular_Season_Player_Stats.TeamID = Team.TeamID
WHERE Regular_Season_Player_Stats.Year = '2008-09'
GROUP BY Team.Team;

-- 12.List the top 5 players with the highest average points per game in the regular season.
SELECT Player, ROUND(AVG(PointsScored / GamesPlayed), 2) AS AvgPointsPerGame
FROM Regular_Season_Player_Stats
WHERE Year = '2008-09'
GROUP BY Player
ORDER BY AvgPointsPerGame DESC
LIMIT 5;

-- 13.Show the total number of assists for each team in the regular season.
SELECT Team.Team, SUM(Assists) AS TotalAssists
FROM Regular_Season_Player_Stats
JOIN Team ON Regular_Season_Player_Stats.TeamID = Team.TeamID
WHERE Regular_Season_Player_Stats.Year = '2008-09'
GROUP BY Team.Team;

-- 14.Display the player with the most steals in the regular season.
SELECT Player, MAX(Steals) AS MaxSteals
FROM Regular_Season_Player_Stats
WHERE Year = '2008-09';


-- 15.List teams with an average efficiency above 15 in the regular season.
SELECT Team.Team
FROM Regular_Season_Player_Stats
JOIN Team ON Regular_Season_Player_Stats.TeamID = Team.TeamID
WHERE Regular_Season_Player_Stats.Year = '2008-09'
GROUP BY Team.Team
HAVING AVG(Efficiency) > 15;

-- 16.Show players who played more than 30 minutes in a single game.
SELECT Player
FROM Regular_Season_Player_Stats
WHERE Year = '2008-09' AND MinutesPlayed > 30;

-- 17.Display players and their teams in the regular season.
SELECT Player, Team.Team
FROM Regular_Season_Player_Stats
JOIN Team ON Regular_Season_Player_Stats.TeamID = Team.TeamID
WHERE Regular_Season_Player_Stats.Year = '2008-09';

-- 18.List players who played for a team in the regular season but not in the playoffs.
SELECT DISTINCT Regular_Season_Player_Stats.Player
FROM Regular_Season_Player_Stats
LEFT JOIN Playoffs_Player_Stats ON Regular_Season_Player_Stats.PlayerID = Playoffs_Player_Stats.PlayerID
WHERE Regular_Season_Player_Stats.Year = '2008-09'
AND Playoffs_Player_Stats.PlayerID IS NULL;

-- 19.Show the teams and the number of players in the regular season.
SELECT Team.Team, COUNT(Regular_Season_Player_Stats.PlayerID) 
AS NumberOfPlayers
FROM Team
LEFT JOIN Regular_Season_Player_Stats ON 
Team.TeamID = Regular_Season_Player_Stats.TeamID
WHERE Regular_Season_Player_Stats.Year = '2008-09'
GROUP BY Team.Team;

-- 20.Show the teams and the number of players in the regular season.
SELECT Team.Team, COUNT(Regular_Season_Player_Stats.PlayerID) 
AS NumberOfPlayers
FROM Team
LEFT JOIN Regular_Season_Player_Stats ON 
Team.TeamID = Regular_Season_Player_Stats.TeamID
WHERE Regular_Season_Player_Stats.Year = '2008-09'
GROUP BY Team.Team;

-- 21.Find the top 3 players with the highest average efficiency in the regular season. Include their team and average efficiency
SELECT Player, Team.Team, AVG(Efficiency) AS AvgEfficiency
FROM Regular_Season_Player_Stats
JOIN Team ON Regular_Season_Player_Stats.TeamID = Team.TeamID
WHERE Regular_Season_Player_Stats.Year = '2008-09'
GROUP BY Player, Team.Team
ORDER BY AvgEfficiency DESC
LIMIT 3;

-- 22.Identify players who had the highest percentage of three-point shots made relative to their total field goals attempted in the regular season.
SELECT Player, (ThreePtFGMade / FGAttempts) AS ThreePtPercentage
FROM Regular_Season_Player_Stats
WHERE Year = '2008-09' AND FGAttempts > 0
ORDER BY ThreePtPercentage DESC
LIMIT 1;

-- 23.List the teams that had the largest difference in average points scored between the regular season and playoffs.
SELECT Team.Team, AVG(Regular_Season_Player_Stats.PointsScored) AS AvgPointsRegularSeason,
  AVG(Playoffs_Player_Stats.PointsScored) AS AvgPointsPlayoffs,
  (AVG(Playoffs_Player_Stats.PointsScored) - AVG(Regular_Season_Player_Stats.PointsScored)) AS PointDifference
FROM Team
JOIN Regular_Season_Player_Stats ON Team.TeamID = Regular_Season_Player_Stats.TeamID
JOIN Playoffs_Player_Stats ON Team.TeamID = Playoffs_Player_Stats.TeamID
WHERE Regular_Season_Player_Stats.Year = '2008-09' AND Playoffs_Player_Stats.Year = '2008-09'
GROUP BY Team.Team
ORDER BY PointDifference DESC
LIMIT 1;

-- 24.Find the player who, in the regular season of 2008-09, had the highest average ratio of points scored to minutes played, excluding players who have played fewer than 500 minutes. Include the player's team, the total number of games played, and the total minutes played. Order the result by the average ratio in descending order.
SELECT Regular_Season_Player_Stats.Player, Team.Team, TotalGamesPlayed, TotalMinutesPlayed,
       AVG(PointsScored / MinutesPlayed) AS AvgPointsToMinutesRatio
FROM (
    SELECT Player, TeamID, SUM(GamesPlayed) AS TotalGamesPlayed,
           SUM(MinutesPlayed) AS TotalMinutesPlayed
    FROM Regular_Season_Player_Stats
    WHERE Year = '2008-09'
    GROUP BY Player, TeamID
    HAVING SUM(MinutesPlayed) >= 500
) AS PlayerTotals
JOIN Regular_Season_Player_Stats ON PlayerTotals.Player = Regular_Season_Player_Stats.Player
                               AND PlayerTotals.TeamID = Regular_Season_Player_Stats.TeamID
JOIN Team ON Regular_Season_Player_Stats.TeamID = Team.TeamID
GROUP BY Regular_Season_Player_Stats.Player, Team.Team, TotalGamesPlayed, TotalMinutesPlayed
ORDER BY AvgPointsToMinutesRatio DESC
LIMIT 1;































































