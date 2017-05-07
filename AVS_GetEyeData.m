clear all
close all

SCR_W = 1280; SCR_H = 960;

NO_OF_FRAMES = 300;

%video_name = '50_people_brooklyn_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = '50_people_brooklyn_no_voices_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = '50_people_london_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = '50_people_london_no_voices_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'advert_bbc4_bees_1024x576'; MOV_W = 1024; MOV_H = 576;
%video_name = 'advert_bbc4_library_1024x576'; MOV_W = 1024; MOV_H = 576;
%video_name = 'advert_bravia_paint_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'advert_iphone_1272x720'; MOV_W = 1272; MOV_H = 720;
%video_name = 'ami_ib4010_closeup_720x576'; MOV_W = 720; MOV_H = 576;
%video_name = 'ami_ib4010_left_720x576'; MOV_W = 720; MOV_H = 576;
%video_name = 'ami_is1000a_closeup_720x576'; MOV_W = 720; MOV_H = 576;
%video_name = 'ami_is1000a_left_720x576'; MOV_W = 720; MOV_H = 576;
%video_name = 'Antarctica_landscape_1246x720'; MOV_W = 1246; MOV_H = 720;
%video_name = 'arctic_bears_1066x710'; MOV_W = 1066; MOV_H = 710;
%video_name = 'basketball_of_sorts_960x720'; MOV_W = 960; MOV_H = 720;
%video_name = 'BBC_life_in_cold_blood_1278x710'; MOV_W = 1278; MOV_H = 710;
%video_name = 'BBC_wildlife_eagle_930x720'; MOV_W = 930; MOV_H = 720;
%video_name = 'BBC_wildlife_serpent_1280x704'; MOV_W = 1280; MOV_H = 704;
%video_name = 'BBC_wildlife_special_tiger_1276x720'; MOV_W = 1276; MOV_H = 720;
%video_name = 'chilli_plasters_1280x712'; MOV_W = 1280; MOV_H = 712;
%video_name = 'DIY_SOS_1280x712'; MOV_W = 1280; MOV_H = 712;
%video_name = 'documentary_adrenaline_rush_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'documentary_coral_reef_adventure_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'documentary_dolphins_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'documentary_mystery_nile_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'documentary_planet_earth_1280x704'; MOV_W = 1280; MOV_H = 704;
%video_name = 'game_trailer_bullet_witch_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'game_trailer_ghostbusters_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'game_trailer_lego_indiana_jones_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'game_trailer_wrath_lich_king_shortened_subtitles_1280x548'; MOV_W = 1280; MOV_H = 548;
%video_name = 'growing_sweetcorn_1280x712'; MOV_W = 1280; MOV_H = 712;
%video_name = 'hairy_bikers_cabbage_1280x712'; MOV_W = 1280; MOV_H = 712;
%video_name = 'harry_potter_6_trailer_1280x544'; MOV_W = 1280; MOV_H = 544;
%video_name = 'home_movie_Charlie_bit_my_finger_again_960x720'; MOV_W = 960; MOV_H = 720;
%video_name = 'hummingbirds_closeups_960x720'; MOV_W = 960; MOV_H = 720;
%video_name = 'hummingbirds_narrator_960x720'; MOV_W = 960; MOV_H = 720;
%video_name = 'hydraulics_1280x712'; MOV_W = 1280; MOV_H = 712;
%video_name = 'movie_trailer_alice_in_wonderland_1280x682'; MOV_W = 1280; MOV_H = 682;
%video_name = 'movie_trailer_ice_age_3_1280x690'; MOV_W = 1280; MOV_H = 690;
%video_name = 'movie_trailer_quantum_of_solace_1280x688'; MOV_W = 1280; MOV_H = 688;
%video_name = 'music_trailer_nine_inch_nails_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'music_gummybear_880x720'; MOV_W = 880; MOV_H = 720;
%video_name = 'music_red_hot_chili_peppers_shortened_1024x576'; MOV_W = 1024; MOV_H = 576;
%video_name = 'music_trailer_nine_inch_nails_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'news_bee_parasites_768x576'; MOV_W = 768; MOV_H = 576;
%video_name = 'news_newsnight_othello_720x416'; MOV_W = 720; MOV_H = 416;
%video_name = 'news_sherry_drinking_mice_768x576'; MOV_W = 768; MOV_H = 576;
%video_name = 'news_tony_blair_resignation_720x540'; MOV_W = 720; MOV_H = 540;
%video_name = 'news_us_election_debate_1080x600'; MOV_W = 1080; MOV_H = 600;
%video_name = 'news_video_republic_960x720'; MOV_W = 960; MOV_H = 720;
%video_name = 'news_wimbledon_macenroe_shortened_768x576'; MOV_W = 768; MOV_H = 576;
%video_name = 'nigella_chocolate_pears_1280x712'; MOV_W = 1280; MOV_H = 712;
%video_name = 'nightlife_in_mozambique_1280x580'; MOV_W = 1280; MOV_H = 580;
%video_name = 'one_show_1280x712'; MOV_W = 1280; MOV_H = 712;
%video_name = 'pingpong_angle_shot_960x720'; MOV_W = 960; MOV_H = 720;
%video_name = 'pingpong_closeup_rallys_960x720'; MOV_W = 960; MOV_H = 720;
%video_name = 'pingpong_long_shot_960x720'; MOV_W = 960; MOV_H = 720;
%video_name = 'pingpong_miscues_1080x720'; MOV_W = 1080; MOV_H = 720;
%video_name = 'pingpong_no_bodies_960x720'; MOV_W = 960; MOV_H = 720;
%video_name = 'planet_earth_jungles_frogs_1280x704'; MOV_W = 1280; MOV_H = 704;
%video_name = 'planet_earth_jungles_monkeys_1280x704'; MOV_W = 1280; MOV_H = 704;
%video_name = 'scottish_starters_1280x712'; MOV_W = 1280; MOV_H = 712;
video_name = 'scottish_parliament_1152x864'; MOV_W = 1152; MOV_H = 864;
%video_name = 'sport_barcelona_extreme_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'sport_cricket_ashes_2007_1252x720'; MOV_W = 1252; MOV_H = 720;
%video_name = 'sport_F1_slick_tyres_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'sport_football_best_goals_976x720'; MOV_W = 976; MOV_H = 720;
%video_name = 'sport_golf_fade_a_driver_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'sport_poker_1280x640'; MOV_W = 1280; MOV_H = 640;
%video_name = 'sport_scramblers_1280x720'; MOV_W = 1280; MOV_H = 720;
%video_name = 'sports_kendo_1280x710'; MOV_W = 1280; MOV_H = 710;
%video_name = 'sport_slam_dunk_1280x704'; MOV_W = 1280; MOV_H = 704;
%video_name = 'sport_surfing_in_thurso_900x720'; MOV_W = 900; MOV_H = 720;
%video_name = 'sport_wimbledon_baltacha_1280x704'; MOV_W = 1280; MOV_H = 704;
%video_name = 'sport_wimbledon_murray_1280x704'; MOV_W = 1280; MOV_H = 704;
%video_name = 'spotty_trifle_1280x712'; MOV_W = 1280; MOV_H = 712;
%video_name = 'stewart_lee_1280x712'; MOV_W = 1280; MOV_H = 712;
%video_name = 'tv_ketch2_672x544'; MOV_W = 672; MOV_H = 544;
%video_name = 'tv_the_simpsons_860x528'; MOV_W = 860; MOV_H = 528;
%video_name = 'tv_uni_challenge_final_1280x712'; MOV_W = 1280; MOV_H = 712;
%video_name = 'university_forum_construction_ionic_1280x720'; MOV_W = 1280; MOV_H = 720;

root = ['/home/anis/avs/Data/GT/' video_name '/event_data/'];

s = dir([root '*.txt']);
file_list = {s.name}'; 

offset_x = (SCR_W - MOV_W) / 2;
offset_y = (SCR_H - MOV_H) / 2;
    
eye_data = false(MOV_H,MOV_W,NO_OF_FRAMES);

for i = 1 : size(file_list,1),
    fid = fopen([root file_list{i}]);

    C = textscan(fid, '%d %f %f %f %d %f %f %f %d');
    
    f = C{1};
    x = int32((C{2}+C{6})/2) - offset_x;
    y = int32((C{3}+C{7})/2) - offset_y;
    is_fix = C{5} == 1 & C{9} == 1;
    
    x(x < 1) = 1; y(y < 1) = 1; x(x > MOV_W) = MOV_W; y(y > MOV_H) = MOV_H;
    e = f <= 300 & is_fix;
    
    %e = f <= 300 & is_fix & x > 0 & y > 0 & x <= MOV_W & y <= MOV_H;
    
    indices = sub2ind(size(eye_data),y(e),x(e),f(e));    
    eye_data(indices) = true;
end

save([root 'eye_data'], 'eye_data');
