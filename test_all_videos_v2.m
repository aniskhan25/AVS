clear all
close all

video_names = { ...
'50_people_brooklyn_1280x720', ...
'50_people_brooklyn_no_voices_1280x720', ...
'50_people_london_1280x720', ...
'50_people_london_no_voices_1280x720', ...
'advert_bbc4_bees_1024x576', ...
'advert_bbc4_library_1024x576', ...
'advert_bravia_paint_1280x720', ...
'advert_iphone_1272x720', ...
'Antarctica_landscape_1246x720', ...
'arctic_bears_1066x710', ...
'basketball_of_sorts_960x720', ...
'BBC_life_in_cold_blood_1278x710', ...
'BBC_wildlife_eagle_930x720', ...
'BBC_wildlife_serpent_1280x704', ...
'BBC_wildlife_special_tiger_1276x720', ...
'chilli_plasters_1280x712', ...
'DIY_SOS_1280x712', ...
'documentary_adrenaline_rush_1280x720', ...
'documentary_coral_reef_adventure_1280x720', ...
'documentary_dolphins_1280x720', ...
'documentary_mystery_nile_1280x720', ...
'documentary_planet_earth_1280x704', ...
'game_trailer_bullet_witch_1280x720', ...
'game_trailer_ghostbusters_1280x720', ...
'game_trailer_lego_indiana_jones_1280x720', ...
'game_trailer_wrath_lich_king_shortened_subtitles_1280x548', ...
'growing_sweetcorn_1280x712', ...
'hairy_bikers_cabbage_1280x712', ...
'harry_potter_6_trailer_1280x544', ...
'home_movie_Charlie_bit_my_finger_again_960x720', ...
'hummingbirds_closeups_960x720', ...
'hummingbirds_narrator_960x720', ...
'hydraulics_1280x712', ...
'movie_trailer_alice_in_wonderland_1280x682', ...
'movie_trailer_ice_age_3_1280x690', ...
'movie_trailer_quantum_of_solace_1280x688', ...
'music_gummybear_880x720', ...
'music_red_hot_chili_peppers_shortened_1024x576', ...
'music_trailer_nine_inch_nails_1280x720', ...
'news_bee_parasites_768x576', ...
'news_sherry_drinking_mice_768x576', ...
'news_us_election_debate_1080x600', ...
'news_video_republic_960x720', ...
'news_wimbledon_macenroe_shortened_768x576', ...
'nigella_chocolate_pears_1280x712', ...
'nightlife_in_mozambique_1280x580', ...
'one_show_1280x712', ...
'pingpong_angle_shot_960x720', ...
'pingpong_closeup_rallys_960x720', ...
'pingpong_long_shot_960x720', ...
'pingpong_miscues_1080x720', ...
'pingpong_no_bodies_960x720', ...
'planet_earth_jungles_frogs_1280x704', ...
'planet_earth_jungles_monkeys_1280x704', ...
'scottish_parliament_1152x864', ...
'scottish_starters_1280x712', ...
'sport_barcelona_extreme_1280x720', ...
'sport_cricket_ashes_2007_1252x720', ...
'sport_F1_slick_tyres_1280x720', ...
'sport_football_best_goals_976x720', ...
'sport_golf_fade_a_driver_1280x720', ...
'sport_poker_1280x640', ...
'sport_scramblers_1280x720', ...
'sports_kendo_1280x710', ...
'sport_slam_dunk_1280x704', ...
'sport_surfing_in_thurso_900x720', ...
'sport_wimbledon_baltacha_1280x704', ...
'sport_wimbledon_murray_1280x704', ...
'spotty_trifle_1280x712', ...
'stewart_lee_1280x712', ...
'tv_ketch2_672x544', ...
'tv_the_simpsons_860x528', ...
'tv_uni_challenge_final_1280x712', ...
'university_forum_construction_ionic_1280x720'};

scores = [];
	
for i = 1 : numel (video_names),
    disp(['video ' num2str(i)]);
    
    video_name = video_names{i};
		
	score = AVS_EvalModel_v1(video_name);
    scores = [scores; score];
end

scores