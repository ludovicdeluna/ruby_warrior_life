module Warbuck
  require 'delegate'

  class Warrior < Character

    def initialize(name='Conan')
      super
      printf "A new %s is born : %s \n", my_class, name
    end

    def do_drink(potion=nil)
      until potion
        puts "You want to drink but you can't remember his name... Shit !"
        return false
      end
      potion_object = Tools.camelcase_to_module(potion)
      if potion_object
        printf "You drink a potion : %s\n", potion
        self.extend(potion_object)
        public_send Tools.camelcase_to_method('Drink' + potion)
        true
      else
        printf "You haven't this %s in your bag... Shame on you !\n", potion
      end
    end

    def do_hit(ennemy=nil)
      if ennemy == 'me'
        puts 'You raise your sword and...'
        do_killme
      else
        puts 'You hit with your sword'
      end
    end

    def do_killme
      printf "%s was just killed by himself\n", self.name
      @stats.pv = 0
    end

    def do_left(potion=nil)
      until potion
        puts "You think you can left a potion effect... But what was his name ?"
        return false
      end
      potion_object = Tools.camelcase_to_module(potion)
      if potion_object
        puts 'You will left a potion effect'
        public_send Tools.to_underscore("Left" + potion.to_s)
        Tools.to_underscore( "Left" + potion.to_s ).tap do |left_potion|
          public_send left_potion.to_sym if respond_to? left_potion.to_sym
        end
        true
      else
        printf "You think you have already drinked a %s... But not", potion_name
      end
    end

    set_commands # Read all do_* methods and create command for each

  end
end
