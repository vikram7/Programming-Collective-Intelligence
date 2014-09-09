require 'pry'

critics = {'Lisa Rose'=> {'Lady in the Water'=> 2.5, 'Snakes on a Plane'=> 3.5,
      'Just My Luck'=> 3.0, 'Superman Returns'=> 3.5, 'You, Me and Dupree'=> 2.5,
      'The Night Listener'=> 3.0},
     'Gene Seymour'=> {'Lady in the Water'=> 3.0, 'Snakes on a Plane'=> 3.5,
      'Just My Luck'=> 1.5, 'Superman Returns'=> 5.0, 'The Night Listener'=> 3.0,
      'You, Me and Dupree'=> 3.5},
     'Michael Phillips'=> {'Lady in the Water'=> 2.5, 'Snakes on a Plane'=> 3.0,
      'Superman Returns'=> 3.5, 'The Night Listener'=> 4.0},
     'Claudia Puig'=> {'Snakes on a Plane'=> 3.5, 'Just My Luck'=> 3.0,
      'The Night Listener'=> 4.5, 'Superman Returns'=> 4.0,
      'You, Me and Dupree'=> 2.5},
     'Mick LaSalle'=> {'Lady in the Water'=> 3.0, 'Snakes on a Plane'=> 4.0,
      'Just My Luck'=> 2.0, 'Superman Returns'=> 3.0, 'The Night Listener'=> 3.0,
      'You, Me and Dupree'=> 2.0},
     'Jack Matthews'=> {'Lady in the Water'=> 3.0, 'Snakes on a Plane'=> 4.0,
      'The Night Listener'=> 3.0, 'Superman Returns'=> 5.0, 'You, Me and Dupree'=> 3.5}}

you = {'Toby'=> {'Snakes on a Plane'=>4.5,'You, Me and Dupree'=>1.0,'Superman Returns'=>4.0}}


def make_plots
  graph_area =
  [
    [' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ']
  ]
end


def sim_pearson(critics_hash, toby_hash)
  mutually_related_array = []

  toby_hash = {'Snakes on a Plane'=>4.5,'You, Me and Dupree'=>1.0,'Superman Returns'=>4.0}

  critics_hash.each do |critic_movie, critic_rating|
    toby_hash.each do |toby_movie, toby_rating|
      if critic_movie == toby_movie
      mutually_related_array <<  [critic_rating, toby_rating]
     end
    end
  end

  n = mutually_related_array.length
  if n == 0
    return 0
  else
    sum_critic = 0
    sum_toby = 0
    sum_critic_squared = 0
    sum_toby_squared = 0
    psum = 0
    mutually_related_array.each do |each_set_of_preferences|
      sum_critic += each_set_of_preferences[0]
      sum_toby += each_set_of_preferences[1]
      sum_critic_squared += each_set_of_preferences[0] * each_set_of_preferences[0]
      sum_toby_squared += each_set_of_preferences[1] * each_set_of_preferences[1]
      psum += each_set_of_preferences[0]*each_set_of_preferences[1]
    end
  end

  numerator = psum - (sum_critic*sum_toby/n)
  denominator = Math.sqrt((sum_critic_squared - (sum_critic)**2/n)*(sum_toby_squared - (sum_toby)**2/n))

  return (numerator / denominator)
end

critics.each do |each_critic, value|
  p each_critic.to_s + ": " + sim_pearson(value, you['Toby']).to_s
end


def hash_of_weighted_scores(critic, sim_pearson_score)


end
