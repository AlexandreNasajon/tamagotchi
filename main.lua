--[[
    Tamagotchi by nasa

    LISTA DE ITENS
    DONE
    - desenhar bicho
    - desenhar stats do bicho
    - feed / play / train
    - contador que aumenta hunger e boredom
    - salvar o jogo
    - new game / continue
    TODO
    - fazenda com vários bichos
    - mandar bicho em aventura
    - encontrar inimigos
    - lutar contra inimigo
    - recrutar inimigo
]]

-- checa se o player clicou dentro do objeto
function inBox( x , y , obj )
    if x >= obj.x and x <= obj.x + obj.w and y >= obj.y and y <= obj.y + obj.h then
        return true
    end
end

-- peguei na net
-- recebe o número índice da linha do arquivo e o arquivo
-- retorna a linha correspondente em forma de string
function fileLine (lineNum, fileName)
    local count = 0
    for line in io.lines(fileName) do
      count = count + 1
      if count == lineNum then return line end
    end
    error(fileName .. " has fewer than " .. lineNum .. " lines.")
end

-- pega as informações no arquivo e coloca nas variáveis correspondentes
function loadGame()
    pet.name = fileLine(1,'file.txt')
    pet.strength = tonumber(fileLine(2,'file.txt'))
    pet.stamina = tonumber(fileLine(3,'file.txt'))
    pet.friendship = tonumber(fileLine(4,'file.txt'))
    pet.hunger = tonumber(fileLine(5,'file.txt'))
    pet.boredom = tonumber(fileLine(6,'file.txt'))
    time = tonumber(fileLine(7,'file.txt')) 
end

-- substitui cada linha do arquivo pelo que estiver nas variáveis do pet
function saveGame()
    local file = io.open('file.txt','w')
    file:write(pet.name, "\n")
    file:write(pet.strength, "\n")
    file:write(pet.stamina, "\n")
    file:write(pet.friendship, "\n")
    file:write(pet.hunger, "\n")
    file:write(pet.boredom, "\n")
    file:write(time,"\n")
    file:close()
end

-- TODO
-- quando fecham a janela do jogo, o love chama a função love.quit
-- guarda o horário e a data
-- usa pra calcular quanto tempo o player ficou sem jogar
function love.quit()
    --[[TODO 
        quando player fechar a janela, guarda o horário e a data pra calcular o tempo

        os.time() => 1476852730 -- seconds since epoch
        os.date("%X", os.time()) => 00:50:02
        os.date("%c", os.time()) => "Wed Oct 19 00:50:02 2016"

    ]]
    print("Thanks for playing! Come back soon!")
  end

function love.load()
    font = love.graphics.newFont(24)
    if not time then time = 0 end
    animationCounter = 0
    hungerCounter = 0
    boredomCounter = 0
    --w, h = love.graphics.getDimensions()
    screenSize = love.window.setMode( 640, 640 )
    backgroundColor = {189/255 , 195/255 , 199/255} -- lilás bem claro acinzentado
    love.graphics.setBackgroundColor( backgroundColor )
    love.graphics.setColor( 0 , 0 , 0 )
    continue = {
        text = love.graphics.newText( font , 'CONTINUE' ),
        box = {x = 200 , y = 100 , w = 100 , h = 40}
    }
    newGame = {
        text = love.graphics.newText( font , 'NEW GAME' ),
        box = {x = 200 , y = 150 , w = 100 , h = 40}
    }
    pet = {}
    feed = {
        text = love.graphics.newText( font , 'FEED' ),
        box = {x = 200 , y = 400 , w = 100 , h = 40},
        anim = love.graphics.newText( font , 'FEEDING' )
    }
    play = {
        text = love.graphics.newText( font , 'PLAY' ),
        box = {x = 200 , y = 440 , w = 100 , h = 40},
        anim = love.graphics.newText( font , 'PLAYING' )
    }
    train = {
        text = love.graphics.newText( font , 'TRAIN' ),
        box = {x = 200 , y = 480 , w = 100 , h = 40},
        anim = love.graphics.newText( font , 'TRAINING' )
    }
    adventure = {
        text = love.graphics.newText( font , 'ADVENTURE' ),
        box = {x = 200 , y = 520 , w = 100 , h = 40}
    }
    animation = love.graphics.newText( font , '' )
    pet_2 = love.graphics.newImage( "images/Pet_2.png" )
    loadGame()
    menu = true
end

function love.update(dt)
    saveGame()
    time = time + 1/60
    hungerCounter = hungerCounter + dt
    if hungerCounter > 5 then
        pet.hunger = pet.hunger + 1
        hungerCounter = 0
    end
    boredomCounter = boredomCounter + dt
    if boredomCounter > 10 then
        pet.boredom = pet.boredom + 1
        boredomCounter = 0
    end
    animationCounter = animationCounter + dt
    if animationCounter >= 4 then
        if not (animation == love.graphics.newText( font , '' )) then
            animation = love.graphics.newText( font , '' )
            animationCounter = 0
        end
    end
end

function love.draw()
    if menu then
        mainMenu = love.graphics.newText( font , 'MAIN MENU' )
        love.graphics.draw(mainMenu , 200 , 50)
        love.graphics.draw(continue.text , continue.box.x , continue.box.y)
        love.graphics.draw(newGame.text , newGame.box.x , newGame.box.y)
    elseif farm then
        love.graphics.print(math.floor(time))
        love.graphics.print('Name: '..pet.name , 0 , 20)
        love.graphics.print('Strength: '..pet.strength , 0 , 40)
        love.graphics.print('Stamina: '..pet.stamina , 0 , 60)
        love.graphics.print('Friendship: '..pet.friendship , 0 , 80)
        love.graphics.print('Hunger: '..pet.hunger , 0 , 100)
        love.graphics.print('Boredom: '..pet.boredom , 0 , 120)
        love.graphics.draw(pet_2 , 200 , 200 )
        love.graphics.draw(play.text , play.box.x , play.box.y )
        love.graphics.draw(feed.text , feed.box.x , feed.box.y )
        love.graphics.draw(train.text , train.box.x , train.box.y )
        love.graphics.draw(adventure.text , adventure.box.x , adventure.box.y )
        love.graphics.draw(animation , 200 , 100 )
    elseif inAdventure then
        -- TODO
        adv = love.graphics.newText( font , 'ADVENTURE' )
        love.graphics.draw(adv , 200 , 50)
        
    end
end

function atMenu( x , y , button , istouch )
    if button == 1 then
        if inBox( x , y , continue.box) then
            menu = false
            farm = true
        elseif inBox( x , y , newGame.box) then
            pet = {
                name = '',
                strength = 1,
                stamina = 5,
                friendship = 0,
                hunger = 5,
                boredom = 5
            }
            time = 0
            menu = false
            farm = true
        end
    end
end

function atFarm( x , y , button , istouch )
    if button == 1 then
        if inBox(x,y,play.box) then -- PLAY
            animation = play.anim
            if pet.boredom > 0 then
                pet.boredom = pet.boredom - 1
            end
        elseif inBox(x,y,feed.box) then -- FEED
            animation = feed.anim
            if pet.hunger > 0 then
                pet.hunger = pet.hunger - 1
            end
        elseif inBox(x,y,train.box) then -- TRAIN
            animation = train.anim
            if pet.strength < 10 then
                pet.strength = pet.strength + 1
            end
        elseif inBox(x,y,adventure.box) then
            farm = false
            inAdventure = true
        end
    end
end

function atAdventure( x , y , button , istouch )
    --TODO
    if button == 1 then

    end
end

function love.mousepressed( x , y , button , istouch )

    if menu then
        atMenu( x , y , button , istouch )
    end

    if farm then
        atFarm( x , y , button , istouch )
    end

    if adventure then
        atAdventure( x , y , button , istouch )
    end

end
