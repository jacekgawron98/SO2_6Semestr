import pygame
import sys
import numpy

cnt = 0
WIDTH = 600
HEIGHT = 600    
BOARD_ROWS = 3
BOARD_COLS = 3
BG_COLOR = (255,255,255)
LINE_COLOR = (125,125,125)
player_turn = 2
enemy_turn = 1

def draw_lines():
    pygame.draw.line(screen, LINE_COLOR, (0,200), (600,200), 10)
    pygame.draw.line(screen, LINE_COLOR, (0,400), (600,400), 10)
    pygame.draw.line(screen, LINE_COLOR, (200,0), (200,600), 10)
    pygame.draw.line(screen, LINE_COLOR, (400,0), (400,600), 10)

def mark_square(row,col,player):
    board[row,col] = player

def check_if_empty(row,col):
    return board[row,col] == 0

def draw_figures():
    for row in range(BOARD_ROWS):
        for col in range(BOARD_COLS):
            if board[row,col] == 1:
                pygame.draw.circle(screen,(255,0,0),(int(col * 200 + 200 // 2),int(row * 200 + 200 // 2)),60,15)
            elif board[row,col] == 2:
                pygame.draw.line( screen, (0,0,255), (col * 200 + 55, row * 200 + 200 - 55), (col * 200 + 200 - 55, row * 200 + 55), 15)
                pygame.draw.line( screen, (0,0,255), (col * 200 + 55, row * 200 + 55), (col * 200 + 200 - 55, row * 200 + 200 - 55),15)

def computer_move():
    bestScore = -800
    bestMoveRow = 0
    bestMoveCol = 0
    for row in range(BOARD_ROWS):
        for col in range(BOARD_COLS):
            if (board[row,col] == 0):
                board[row,col] = enemy_turn
                score = minimax(board, 0, False)
                board[row,col] = 0
                if (score > bestScore):
                    bestScore = score
                    bestMoveRow = row
                    bestMoveCol = col

    insert(bestMoveRow,bestMoveCol,enemy_turn)
    return

def minimax(board_to_check,depth,is_max):
    if (check_win(enemy_turn,False)):
        return 1
    elif (check_win(player_turn,False)):
        return -1
    elif (check_draw()):
        return 0

    if is_max:
        best_score = -800
        for row in range(BOARD_ROWS):
            for col in range(BOARD_COLS):
                if (board[row,col] == 0):
                    board[row,col] = enemy_turn
                    score = minimax(board, depth + 1, False)
                    board[row,col] = 0
                    if (score > best_score):
                        best_score = score
        return best_score
    else:
        best_score = 800
        for row in range(BOARD_ROWS):
            for col in range(BOARD_COLS):
                if (board[row,col] == 0):
                    board[row,col] = player_turn
                    score = minimax(board, depth + 1, True)
                    board[row,col] = 0
                    if (score < best_score):
                        best_score = score
        return best_score

def check_win(player,do_draw):
    for row in range(BOARD_ROWS):
        if board[row,0] == player and board[row,1] == player and board[row,2] == player:
            if do_draw:
                draw_horizontal_win(row)
            return True
    for col in range(BOARD_COLS):
        if board[0,col] == player and board[1,col] == player and board[2,col] == player:
            if do_draw:
                draw_vertical_win(col)
            return True
    if board[0,0] == player and board[1,1] == player and board[2,2] == player:
        if do_draw:
            draw_diagonal_win_right()
        return True
    if board[0,2] == player and board[1,1] == player and board[2,0] == player:
        if do_draw:
            draw_diagonal_win_left()
        return True
    return False

def check_draw():
    for row in range(BOARD_ROWS):
        for col in range(BOARD_COLS):
            if board[row,col] == 0:
                return False
    return True

def insert(row,col,player):
    if(check_if_empty(row,col)):
        board[row,col] = player
        draw_figures()
        if check_win(1,True):
            finish_game(1)
        elif check_win(2,True):
            finish_game(2)
        elif check_draw():
            finish_game(0)

def draw_horizontal_win(row):
    pos = row * 200 + 200 // 2
    pygame.draw.line( screen, (0,0,0), (15,pos), (WIDTH -15, pos), 15)

def draw_vertical_win(col):
    pos = col * 200 + 200 // 2
    pygame.draw.line( screen, (0,0,0), (pos,15), (pos,HEIGHT - 15), 15)

def draw_diagonal_win_left():
    pygame.draw.line( screen, (0,0,0), (15, HEIGHT - 15), (WIDTH - 15, 15), 15)

def draw_diagonal_win_right():
    pygame.draw.line( screen, (0,0,0), (15, 15), (WIDTH - 15, HEIGHT - 15), 15)

def restart():
    print("starting game")
    screen.fill( BG_COLOR )
    draw_lines()
    for row in range(BOARD_ROWS):
        for col in range(BOARD_COLS):
            board[row,col] = 0
    if enemy_turn == 1:
        computer_move()

def finish_game(winner):
    if winner == 0:
        text = 'Tie!'
    else:
        text = 'You won!' if winner == player_turn else "You lost :("
    info = 'Press R to restart'
    game_over = False
    text = myfont.render(text, False, (0, 0, 0))
    info = myfont.render(info, False, (0, 0, 0))
    screen.blit(text,(240,30))
    screen.blit(info,(190,70))

print("Do you want to be O or X? (O starts the game): ")
choice = input()
if choice == 'X' or choice == 'x':
    player_turn = 2
    enemy_turn = 1
elif choice == 'O' or choice == 'o':
    player_turn = 1
    enemy_turn = 2
else:
    print('Invalid input')
    sys.exit()

pygame.init()
pygame.font.init()
myfont = pygame.font.SysFont('Arial', 30)

game_over = True

screen = pygame.display.set_mode( (WIDTH,HEIGHT) )
pygame.display.set_caption( 'TIC TAC TOE' )
screen.fill(BG_COLOR)

board = numpy.zeros((BOARD_ROWS,BOARD_COLS))

restart()


while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            sys.exit()
        if event.type == pygame.MOUSEBUTTONDOWN:
            mouse_x = event.pos[0]
            mouse_y = event.pos[1]

            clicked_row = ( mouse_y // 200 )
            clicked_col = ( mouse_x // 200 )
            if game_over:
                insert(clicked_row,clicked_col,player_turn)
                computer_move()

        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_r:
                restart()
                game_over = True

    pygame.display.update()
    
