Create database Spotify;
use spotify;
select Count(*) from spotify;

-- Q1) What are the top 10 tracks with the highest number of streams?
select track_name, artist_name, Streams from spotify 
order by Streams desc
Limit 10;

-- Q2) Which artist has the most tracks in the dataset, and how many tracks do they have?
Select artist_name,Count(track_name) as Track_count from spotify
Group by artist_name
Order by Track_count desc 
Limit 1;

-- Q3) How many tracks were released each year?
Select released_year,Count(Track_name) as Total_songs From spotify
Group by released_year
Order by released_year desc;

-- Q4) What percentage of tracks are included in Spotify, Apple, and Deezer playlists?
Select round(count(Case When spotify_playlists > 0 Then track_name END)*100.0/Count(track_name),2) AS 'Spotify_%',
       round(count(Case When apple_playlists > 0 Then track_name END)*100.0/Count(track_name),2) AS 'apple_%',
       round(count(Case When deezer_playlists > 0 Then track_name END)*100.0/Count(track_name),2) AS 'deezer_%'
From spotify;

-- Q5) What is the average BPM (beats per minute) of tracks released in each year?
Select released_year, Avg(BPM) as Average_BPM From Spotify
Group by released_year;

-- Q6) What are the Top 5 Most Streamed Tracks Released in Each Year? 
With RankedTracks AS(
	Select Released_year, Track_name, Artist_name, Streams,
    Rank() Over(Partition by Released_year Order by streams DESC) as Rank_num
    From spotify)
Select Released_year, Track_name, Artist_name, Streams FRom RankedTracks
where rank_num<=5
Order by Released_year desc, Rank_num;
    
-- Q7) How many tracks are classified as major vs minor mode?
Select Mode, Count(mode) as Mode_count
From spotify
group by Mode;

-- Q8) Which tracks have consistently appeared in the top charts across Spotify, Apple, and Deezer?
Select Track_name, Artist_name From Spotify
WHERE track_name in (spotify_charts AND apple_charts AND deezer_charts);

-- Q9) What is the average energy level of tracks by artist?
Select Artist_name, Round(avg(`energy_%`),2) as Energy_Level from spotify
GROUP BY artist_name;

-- Q10) How has the average energy level of tracks changed from year to year?
Select Released_year,avg(`energy_%`) from spotify
Group by Released_year
ORDER BY released_year DESC;
