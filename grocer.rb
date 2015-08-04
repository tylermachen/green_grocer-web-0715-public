def consolidate_cart(cart:[])
  cart.uniq.each_with_object({}) do |item, new_cart|
    name = item.keys.first
    attributes = item.values.first
    attributes[:count] = cart.count(item)
    new_cart[name] = attributes
  end
end


def apply_coupons(cart:[], coupons:[])
  coupons.each_with_object(cart) do |coupon|
    coupon_item = coupon[:item]
    coupon_price = coupon[:cost]
    coupon_count = coupon[:num]

    next unless cart.include?(coupon_item)
    
    if cart[coupon_item][:count] >= coupon_count
      if cart.include?("#{coupon_item} W/COUPON")
        cart["#{coupon_item} W/COUPON"][:count] += 1
      else  
        cart["#{coupon_item} W/COUPON"] = {
          price: coupon_price, 
          clearance: cart[coupon_item][:clearance], 
          count: 1
        }
      end

      cart[coupon_item][:count] -= coupon_count
    end
  end  
end

def apply_clearance(cart:[])
  cart.each_with_object(cart) do |item|
    clearance = item.last[:clearance]
    price = item.last[:price]
    item.last[:price] = price - (price * 0.20) if clearance
  end
end

def checkout(cart:[], coupons:[])
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)

  t = 0
  cart.each do |item| 
    t += (item.last[:price] * item.last[:count])
  end
  t = t - (t * 0.10) if t > 100; t
end