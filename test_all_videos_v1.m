clear all
close all


addpath('./OF');
addpath('./OF/mex');

addpath(genpath('./edison_matlab_interface'));

addpath('./audioread');

video_names = { ...
	%'50_people_brooklyn_no_voices_1280x720', ...
	%'50_people_london_no_voices_1280x720', ...
	%'BBC_life_in_cold_blood_1278x710', ...
	%'BBC_wildlife_eagle_930x720', ...
	%'BBC_wildlife_serpent_1280x704', ...
	%'documentary_dolphins_1280x720', ...
	%'documentary_mystery_nile_1280x720', ...
	%'game_trailer_wrath_lich_king_shortened_subtitles_1280x548', ...
	%'growing_sweetcorn_1280x712', ...
	%'hummingbirds_narrator_960x720', ...
	%'hydraulics_1280x712', ...
	%'movie_trailer_alice_in_wonderland_1280x682', ...
	%'movie_trailer_ice_age_3_1280x690', ...
	%'movie_trailer_quantum_of_solace_1280x688', ...
	'music_gummybear_880x720', ...
	'music_red_hot_chili_peppers_shortened_1024x576', ...
	'news_video_republic_960x720', ...
	'news_wimbledon_macenroe_shortened_768x576', ...
	'nigella_chocolate_pears_1280x712', ...	
	'scottish_starters_1280x712', ...
	'sport_barcelona_extreme_1280x720', ...
	'sport_cricket_ashes_2007_1252x720', ...
	'sport_F1_slick_tyres_1280x720', ...
	'sport_slam_dunk_1280x704', ...
	'sport_surfing_in_thurso_900x720', ...
	'spotty_trifle_1280x712'};

for i = 1 : numel (video_names),
    disp(['video ' num2str(i)]);
    
    video_name = video_names{i};
	audio_name = [video_name, '.wav'];
	
    compute_audioVisualSaliency( video_name, audio_name);
end
