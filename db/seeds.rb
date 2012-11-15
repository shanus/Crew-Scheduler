puts 'CREATING ROLES'
Role.create([
  { :name => 'admin' }, 
  { :name => 'member' }
], :without_protection => true)
puts 'SETTING UP DEFAULT USER LOGIN'
u = User.find_or_initialize_by_email "shaun@yarmouth-rowing.org"
if u.new_record?
  if u.password.nil?
    u.password = "changeme"
    u.password_confirmation = "changeme"
  end
  u.first_name = "Shaun"
  u.last_name = "Meredith"
  u.side = "stbd"
  u.confirmed_at = Time.now
  u.save
end
u.add_role :admin

puts 'CREATING DEFAULT TEAM'
team = Team.find_or_create_by_name "Pickup"

puts 'CREATING HULL TYPES'
sculls = Category.find_or_create_by_name "Sculls"
if sculls
  sculls.hulls.find_or_create_by_name_and_seats "Single","1x"
  sculls.hulls.find_or_create_by_name_and_seats "Double","2x"
  sculls.hulls.find_or_create_by_name_and_seats "Quad","4x"
end
sweeps = Category.find_or_create_by_name "Sweeps"
if sweeps
  sweeps.hulls.find_or_create_by_name_and_seats "Pair","2-"
  sweeps.hulls.find_or_create_by_name_and_seats "Pair, coxed","2+"
  sweeps.hulls.find_or_create_by_name_and_seats "Four, coxless","4-"
  sweeps.hulls.find_or_create_by_name_and_seats "Four, coxed","4+"
  sweeps.hulls.find_or_create_by_name_and_seats "Eight","8+"
end

puts 'CREATING USAGE TYPES'
Usage.find_or_create_by_name "Any"
Usage.find_or_create_by_name "Novice"
Usage.find_or_create_by_name "Beginner"
Usage.find_or_create_by_name "Recreational"
Usage.find_or_create_by_name "Competitive"
Usage.find_or_create_by_name "Elite/Racing"

puts 'CREATING BOAT WEIGHTS'
Weight.find_or_create_by_name "Lightweight"
Weight.find_or_create_by_name "Midweight"
Weight.find_or_create_by_name "Heavyweight"