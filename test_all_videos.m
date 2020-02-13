clear all
close all

video_names = { ...
    '50_people_brooklyn_1280x720', ...
    'advert_bbc4_bees_1024x576', ...
    'advert_bbc4_library_1024x576', ...
    'advert_bravia_paint_1280x720', ...
    'arctic_bears_1066x710', ...
    'basketball_of_sorts_960x720', ...
    'BBC_wildlife_special_tiger_1276x720', ...
    'DIY_SOS_1280x712', ...
    'documentary_adrenaline_rush_1280x720', ...
    'documentary_coral_reef_adventure_1280x720', ...
    'game_trailer_lego_indiana_jones_1280x720', ...    
    'hairy_bikers_cabbage_1280x712', ...
    'harry_potter_6_trailer_1280x544', ...
    'home_movie_Charlie_bit_my_finger_again_960x720', ...
    'hummingbirds_closeups_960x720', ...
    'music_trailer_nine_inch_nails_1280x720', ...
    'news_bee_parasites_768x576', ...
    'news_sherry_drinking_mice_768x576', ...
    'news_us_election_debate_1080x600', ...
    'one_show_1280x712', ...
    'pingpong_angle_shot_960x720', ...
    'planet_earth_jungles_monkeys_1280x704', ...
    'scottish_parliament_1152x864', ...
    'sport_football_best_goals_976x720', ...
    'stewart_lee_1280x712'};

len = numel (video_names);

scores = [];

for i = 1 : len,
    disp(['video ' num2str(i)]);
    
    video_name = video_names{i};
    
    compute_motionMaps_v1(video_name);
    
    compute_avSaliencyMap(video_name)
    
    scores = [scores; AVS_EvalModel_v1(video_name)];
    
end

scores