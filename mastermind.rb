class Board
	def initialize
		@secret = { first: "", second: "", third: "", fourth: "" }
		@pegs = { first: "", second: "", third: "", fourth: "" }
	end

	def set_pegs(position, value)
		@pegs[position] = value
	end

	def display(fb)
		str = "  "
		puts ""
		puts "    1   2   3   4        B   W"
		puts "  +---+---+---+---+    +---+---+"
		@pegs.each { |k, v| str += "| #{v} " }
		str += "|    "
		fb.each { |i| str += "| #{i} " }
		puts str + "|"
		puts "  +---+---+---+---+    +---+---+"
		puts ""
	end

	def get_feedback
		white = 0
		black = 0
		secret_colors = @secret.values
		peg_colors = @pegs.values
		# check if any pegs are correct color in correct position
		peg_colors.each_with_index do |color, i| 
			if secret_colors[i] == color
				black += 1
				secret_colors[i] = "*"
				peg_colors[i] = "*"
			end
		end
		# now check if any remaining pegs are correct color but in wrong position
		peg_colors.each_with_index do |color, i|
			if color != "*"
				if secret_colors.index(color) != nil
					white += 1
					secret_colors[secret_colors.index(color)] = "$"
				end
			end
		end
		[black, white]
	end

	def enter_guess(peg, color)
		case peg
		when 0
			@pegs[:first] = color
			return true
		when 1
			@pegs[:second] = color
			return true
		when 2
			@pegs[:third] = color
			return true
		when 3
			@pegs[:fourth] = color
			return true
		else
			return false
		end
	end

	def generate_secret_code
		colors = ["P", "G", "B", "R", "Y", "O"]
		@secret.keys.each { |k| @secret[k] = colors.sample }
	end

	def display_secret_code
		puts "  Answer:"
		puts ""
		puts "    1   2   3   4"
		puts "  +---+---+---+---+"
		str = "  "
		@secret.each { |k, v| str += "| #{v} " }
		str += "|"
		puts str
		puts "  +---+---+---+---+"
		puts ""
	end

end

class Game
	def initialize
		@board = Board.new
		@tries = 12
	end

	def play
		@board.generate_secret_code
		win = false
		quit = false
		pass = 1
		puts ""
		while not win
			valid = true
			puts "  Guess #{pass} of #{@tries}"
			print "  Enter Four Pegs (B,G,O,P,R,Y) separated by spaces: " 
			colors = gets.chomp.upcase
			colors.split(" ").each do |color| 
				if not ["B", "G", "O", "P", "R", "Y"].include?(color)
					valid = false
				end	
				quit = true if color == "QUIT"
			end
			if quit
				puts ""
				puts "  Quiting..."
				puts ""
				break
			end
			if not valid
				puts ""
				puts "  Invalid Entry - Try Again!"
				next
			end
			# validate entry here
			colors.split(" ").each_with_index do |color, i| 
				@board.enter_guess(i, color)
			end
			fb = @board.get_feedback
			@board.display(fb)
			if fb[0] == 4
				puts "  You Win in #{pass} Guesses!! - Game Over!"
				puts ""
				break
			else
				if pass == @tries
					puts "  No More Guesses!! - Game Over!"
				  puts ""
					@board.display_secret_code
					break
				end
			end
			pass += 1
		end
	end
end

game = Game.new
game.play

