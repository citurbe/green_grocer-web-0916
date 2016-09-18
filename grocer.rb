
=begin
[
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"KALE"    => {:price => 3.0, :clearance => false}}
]


{
  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 2},
  "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
}
=end
require 'pry'

def consolidate_cart(cart)
  output_hash = {}
  cart.each do |item_hash|
  	item_hash.each do |item_name, properties_hash|
  		if !output_hash.keys.include?(item_name)
  			properties_with_count = properties_hash
  			properties_with_count[:count] = 1
  			output_hash[item_name] = properties_with_count
  		else
  			output_hash[item_name][:count] += 1
  		end
  	end
  end
  output_hash
  	

end

def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
  if cart.keys.include?(coupon_hash[:item]) && cart[coupon_hash[:item]][:count] >= coupon_hash[:num]


  	item_before_discount = cart[coupon_hash[:item]]
  	new_title = "#{coupon_hash[:item]} W/COUPON"
  	if cart.keys.include?(new_title)
  		cart[new_title][:count] += 1
  	else
  		cart[new_title] = {
  			price: coupon_hash[:cost],
  			count: 1,
  			clearance: item_before_discount[:clearance]
  		}
  	end
  
  	new_count = cart[coupon_hash[:item]][:count] - coupon_hash[:num]

  	if new_count > 0
  		cart[coupon_hash[:item]][:count] = new_count
  	else
  		cart[coupon_hash[:item]][:count] = 0
  	end
  end
end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info_hash|
  	if info_hash[:clearance] == true
  		cart[item][:price] = cart[item][:price] - (cart[item][:price] * 0.2)
  	end
  	end
  	cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = (apply_clearance(coupon_cart))

  total = 0
  final_cart.each do |item, properties_hash|
  	total += (properties_hash[:price] * properties_hash[:count])
  end
  
  total -= total * 0.1 if total > 100
  total
end
