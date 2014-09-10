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

def sim_pearson(critics_hash, toby_hash)
  mutually_related_array = []

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

def find_my_unrated_items(critic, toby_hash)
  unique_array = []
  critic.each do |each_movie, rating|
    unique_array << each_movie
  end
  unique_array.uniq!
  toby_array = []
  toby_hash["Toby"].each do |each_movie, each_rating|
    toby_array << each_movie
  end

  return unique_array - toby_array
end

def expected_values_for_unseen_movies_by_critic(critic, you)
  expected_values_for_unseen_movies = Hash.new
  # output should equal {"Lady in the Water" => 2.5*0.99, "Just My Luck" => 3*0.99, "The Night Listener" => 3*0.99}
  # }
  sim_pearson_score = sim_pearson(critic, you['Toby'])
  find_my_unrated_items(critic, you).each do |each_movie|
    expected_values_for_unseen_movies[each_movie] = critic[each_movie] * sim_pearson_score
  end
  return expected_values_for_unseen_movies
end

def expected_values_for_unseen_movies_for_all_critics(critics, you)

  # output should equal {'Lisa Rose' => {"Lady in the Water" => 2.5*0.99, "Just My Luck" => 3*0.99, "The Night Listener" => 3*0.99},
  #   {'Claudia Puig' => {"Just My Luck" => 0.89*3.0, "The Night Listener" => 0.89*4.5}
  # }

  output = Hash.new
  output_array = []
  critics.each do |each_critic, value|
    output_array << expected_values_for_unseen_movies_by_critic(critics[each_critic], you)
  end

return output_array
end

def create_hash_of_expected_ratings(critics, you)
  b = Hash.new([])

  expected_values_for_unseen_movies_for_all_critics(critics, you).each do |hash|
    hash.each do |each_movie, each_rating|
      b[each_movie] += [each_rating] if each_rating > 0
    end
  end

  return b
end

def hash_of_sims_of_all_critics(critics, you)
  output = Hash.new(0)
  critics.each do |each_critic, value|
    output[each_critic] = sim_pearson(value, you['Toby'])
  end
  output
end

def has_critic_reviewed_a_movie?(critic, critics, movie_title)
  critics[critic].has_key?(movie_title)
end

def sim_sum_per_movie(hash_of_sims_of_all_critics, create_hash_of_expected_ratings, critics)
  #output should be {"Lady in the Water" => [0.99, 0.38, 0.92, 0.66], "Just My Luck" => [0.99, 0.38, 0.89, 0.92], "The Night Listener" => [0.99, 0.38, 0.89, 0.92, 0.66]}

  output = Hash.new([])
  critics.each do |each_critic, value|
    value.each do |each_movie, each_rating|
      output[each_movie] += [hash_of_sims_of_all_critics[each_critic]] if hash_of_sims_of_all_critics[each_critic] > 0
    end
  end

  return output
end

def movie_rating_predictions_hash(create_hash_of_expected_ratings, sim_sum_per_movie)
  output = Hash.new(0)
  create_hash_of_expected_ratings.each do |each_movie, array_of_expected_ratings|
    output[each_movie] = array_of_expected_ratings.inject(:+)
  end

  output_sims = Hash.new(0)
  sim_sum_per_movie.each do |each_movie, sims|
    output_sims[each_movie] = sims.inject(:+)
  end

  final_output = Hash.new(0)
  output.each do |each_movie, sum|
    final_output[each_movie] = output[each_movie] / output_sims[each_movie].to_f
  end

  final_output
end

puts
puts "===== pearson sim scores for each critic: hash_of_sims_of_all_critics ===="
puts

p hash_of_sims_of_all_critics(critics, you)

puts
puts "===== array of expectations: expected_values_for_unseen_movies_for_all_critics====="
puts

p expected_values_for_unseen_movies_for_all_critics(critics, you)

puts
puts "===== hash of expected ratings: create_hash_of_expected_ratings ===="
puts

p create_hash_of_expected_ratings(critics, you)

puts
puts "===== sim sum per movie ===="
puts

p sim_sum_per_movie(hash_of_sims_of_all_critics(critics, you), create_hash_of_expected_ratings(critics,you), critics)

puts
puts "===== movie_ratings_predictions_hash ===="
puts

p movie_rating_predictions_hash(create_hash_of_expected_ratings(critics, you), sim_sum_per_movie(hash_of_sims_of_all_critics(critics, you), create_hash_of_expected_ratings(critics,you), critics))
