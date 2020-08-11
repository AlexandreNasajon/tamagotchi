--[[
    Tamagotchi by nasa

    TODO
    
    FARM
    - desenhar bichos na fazenda
    
    ADVENTURE
    - mandar bicho em aventura
    - encontrar inimigos
    - lutar contra inimigo
    - recrutar inimigo
]]

local Farm = require('Farm')
local Items = require('Items')
local Equip = require('Equip')
local Monsters = require('Monsters')
local Adventure = require('Adventure')


-- checa se o player clicou dentro do objeto
function inBox( x , y , obj )
    if x >= obj.x and x <= obj.x + obj.w and y >= obj.y and y <= obj.y + obj.h then
        return true
    end
end


function love.load()
    font = love.graphics.newFont(24)
    if not time then time = 0 end
    animationCounter = 0
    hungerCounter = 0
    boredomCounter = 0
    screenSize = love.window.setMode( 9*40 , 16*40 )
    backgroundColor = {189/255 , 195/255 , 199/255} -- lilás bem claro
    love.graphics.setBackgroundColor( backgroundColor )
    love.graphics.setColor( 0 , 0 , 0 )
    titleBox = {box = {x = 9*12 , y = 16*2}}
    optionBox_1 = {box = {x = 9*12 , y = 16*20 , w = 140 , h = 40}}
    optionBox_2 = {box = {x = 9*12 , y = 16*24 , w = 140 , h = 40}}
    optionBox_3 = {box = {x = 9*12 , y = 16*28 , w = 140 , h = 40}}
    optionBox_4 = {box = {x = 9*12 , y = 16*32 , w = 140 , h = 40}}
    optionBox_5 = {box = {x = 9*12 , y = 16*36 , w = 140 , h = 40}}

    player = {
        coins = 10,
        gems = 1,
        rank = 'Copper'
    }
    pet1 = {
        name = 'Jer',
        strength = 1,
        stamina = 5,
        carisma = 0,
        img = love.graphics.newImage( "images/pet1.png" ),
        miniImg = love.graphics.newImage( 'images/pet1mini.png')
    }
    pet2 = {
        name = 'Bel',
        strength = 1,
        stamina = 5,
        carisma = 0,
        img = love.graphics.newImage( "images/pet2.png" ),
        miniImg = love.graphics.newImage( 'images/pet2mini.png')
    }
    mainPetBox = {pet = pet1 , box = {x = 9*12 , y = 16*4 }}
    petBox_1 = {pet = pet2 , box = {x = 9*2 , y = 16*8 , w = 50 , h = 50}}
    petBox_2 = {box = {x = 9*2 , y = 16*12 , w = 50 , h = 50}}
    petBox_3 = {box = {x = 9*2 , y = 16*16 , w = 50 , h = 50}}

    menu = true
end

function love.update(dt)
    saveGame()
    time = time + 1/60
end

function love.draw()
    if menu then
        love.graphics.draw(love.graphics.newText( font , 'MAIN MENU' ) , titleBox.box.x , titleBox.box.y )
        love.graphics.draw(love.graphics.newText( font , 'CONTINUE' ) , optionBox_1.box.x , optionBox_1.box.y)
        love.graphics.draw(love.graphics.newText( font , 'NEW GAME' ), optionBox_2.box.x , optionBox_2.box.y)
    elseif farm then
        love.graphics.draw(love.graphics.newText( font , '     FARM' ) , titleBox.box.x , titleBox.box.y  )
        love.graphics.print(math.floor(time))
        love.graphics.print('Creature: '..mainPetBox.pet.name , 0 , 16)
        love.graphics.print('Strength: '..mainPetBox.pet.strength , 0 , 16*2)
        love.graphics.print('Stamina: '..mainPetBox.pet.stamina , 0 , 16*3)
        love.graphics.print('Carisma: '..mainPetBox.pet.carisma , 0 , 16*4)
        love.graphics.print('Coins: '..player.coins , 9*12 , 0)
        love.graphics.print('Gems: '..player.gems , 9*20 , 0)
        love.graphics.print('Rank: '..player.rank , 9*28 , 0)
        love.graphics.draw( mainPetBox.pet.img , mainPetBox.box.x , mainPetBox.box.y )
        if petBox_1.pet then love.graphics.draw( petBox_1.pet.miniImg , petBox_1.box.x , petBox_1.box.y ) end
        if petBox_2.pet then love.graphics.draw( petBox_2.pet.miniImg , petBox_2.box.x , petBox_2.box.y ) end
        if petBox_3.pet then love.graphics.draw( petBox_3.pet.miniImg , petBox_3.box.x , petBox_3.box.y ) end
        love.graphics.draw(love.graphics.newText( font , 'ADVENTURE' ) , optionBox_4.box.x , optionBox_4.box.y )
    elseif adventure then
        love.graphics.draw(love.graphics.newText( font , 'ADVENTURE' ) , titleBox.box.x , titleBox.box.y  )
        love.graphics.draw(love.graphics.newText( font , 'FOREST') , optionBox_1.box.x , optionBox_1.box.y )
    end
end

function atMenu( x , y , button , istouch )
    if button == 1 then
        if inBox( x , y , optionBox_1.box) then -- continue
            loadGame()
            menu = false
            farm = true
        elseif inBox( x , y , optionBox_2.box) then -- new game
            time = 0
            menu = false
            farm = true
        end
    end
end

function atFarm( x , y , button , istouch )
    if button == 1 then
        if inBox(x,y,optionBox_4.box) then
            farm = false
            adventure = true
        elseif inBox(x,y,petBox_1.box) then
            local tmp = petBox_1.pet
            petBox_1.pet = mainPetBox.pet
            mainPetBox.pet = tmp
        end
    end
end

--TODO
function atAdventure( x , y , button , istouch )
    if button == 1 then
        if inBox(x,y,optionBox_1.box) then
            adventure = false
            farm = true
        end
    end
end

function love.mousepressed( x , y , button , istouch )
    if menu then
        atMenu( x , y , button , istouch )
    elseif farm then
        atFarm( x , y , button , istouch )
    elseif adventure then
        atAdventure( x , y , button , istouch )
    end
end


-------------------------------- SAVE/LOAD GAME ----------------------------------------




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
    pet1.name = fileLine(1,'file.txt')
    pet1.strength = tonumber(fileLine(2,'file.txt'))
    pet1.stamina = tonumber(fileLine(3,'file.txt'))
    pet1.carisma = tonumber(fileLine(4,'file.txt'))
    time = tonumber(fileLine(5,'file.txt'))
    player.coins = tonumber(fileLine(6,'file.txt'))
    player.gems = tonumber(fileLine(7,'file.txt')) 
    player.rank = fileLine(8,'file.txt')
end

-- substitui cada linha do arquivo pelo que estiver nas variáveis do pet
function saveGame()
    local file = io.open('file.txt','w')
    file:write(pet1.name, "\n")
    file:write(pet1.strength, "\n")
    file:write(pet1.stamina, "\n")
    file:write(pet1.carisma, "\n")
    file:write(time,"\n")
    file:write(player.coins, "\n")
    file:write(player.gems, "\n")
    file:write(player.rank, "\n")
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
