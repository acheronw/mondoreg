# ruby encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
case Rails.env
when "development"
	AdminUser.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password', access_levels: 'super')
	p "adminuser hozzáadva!"
	user=User.new
	user.name = 'Teszt Béla'
	user.email = 'latogato@example.com'
	user.password = 'conjaro'
	user.password_confirmation = 'conjaro'
	user.privacy_accepted = true
	user.skip_confirmation!
	if user.save
		p "user hozzáadva!"
	else
		p user.errors
	end
	user=User.new
	user.name = 'Szervező Szerén'
	user.email = 'szervezo@example.com'
	user.password = 'szekpakolo'
	user.password_confirmation = 'szekpakolo'
	user.privacy_accepted = true
	user.skip_confirmation!
	if user.save
		p "user hozzáadva!"
	else
		p user.errors
	end	
	if convention = Convention.create(name: 'Első Con', opening: '2021/09/20', relevance_date: '2025/12/25')
		p "con hozzáadva"
	else
		p convention.errors
	end
	Competition.create(name: 'Első verseny', applications_start: '2021/09/20', applications_end: '2025/12/25', convention: convention, subtype: 'craft', admin_email: 'admin@example.com' )
	p "competition hozzáadva"
	Ticket.create(convention: convention, price: 5000, sale_start: '2021/09/15', sale_end: '2025/12/20')
end