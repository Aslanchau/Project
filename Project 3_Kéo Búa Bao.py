import random
rock = '''
    _______
---'   ____)
      (_____)
      (_____)
      (____)
---.__(___)
'''

paper = '''
    _______
---'   ____)____
          ______)
          _______)
         _______)
---.__________)
'''

scissors = '''
    _______
---'   ____)____
          ______)
       __________)
      (____)
---.__(___)
'''
game_images = [rock, paper, scissors]



#list of choices
user_choice = int(input("What do you choose? Type 0 for Rock, 1 for paper and 2 for Scissor"))   
if user_choice >= 0 and user_choice <= 2:
    print (game_images [user_choice])

#0, 1, 2
computer_choice = random.randint(0, 2)
print ('Computer choose:')
print (game_images [computer_choice])

if user_choice >= 3 or user_choice < 0:
    print('You typed invalid number. You lose!')
elif user_choice == 0 and computer_choice ==1:
    print  ('You win !')
elif computer_choice == 0 and user_choice == 2:
    print ('You lose !')
elif user_choice > computer_choice:
    print ('You win !')
elif computer_choice > user_choice:
    print ('Computer win')
elif computer_choice == user_choice :
    print ("It's a draw !")

