stages = ['''
  +---+
  |   |
  O   |
 /|\  |
 / \  |
      |
=========
''', '''
  +---+
  |   |
  O   |
 /|\  |
 /    |
      |
=========
''', '''
  +---+
  |   |
  O   |
 /|\  |
      |
      |
=========
''', '''
  +---+
  |   |
  O   |
 /|   |
      |
      |
=========''', '''
  +---+
  |   |
  O   |
  |   |
      |
      |
=========
''', '''
  +---+
  |   |
  O   |
      |
      |
      |
=========
''', '''
  +---+
  |   |
      |
      |
      |
      |
=========
''']

import random
from hangmanwords import word_list  # Import word_list từ module hangmanwords

lives = 6  # Số mạng mình còn sống

chosen_word = random.choice(word_list)
print(chosen_word)

placeholder = ""
word_length = len(chosen_word)
for position in range(word_length):
    placeholder += " _ "
print (placeholder)

game_over = False
correct_letters = []

while not game_over:
    guess = input("Guess a letter: ").lower()
    print("****************************<???>/6 LIVES LEFT****************************")
    display = ""
    
    for letter in chosen_word:
        if letter == guess:
            display += letter
            correct_letters.append(guess)
        elif letter in correct_letters:
            display += letter
        else:
            display += " _ "
        
    print (display)
    
    if guess not in chosen_word:
        lives -= 1
        if lives == 0:
            game_over = True
            print("***********************YOU LOSE**********************")
        
    if " _ " not in display:
        game_over = True
        print("****************************YOU WIN****************************")
        
    print (stages[lives])