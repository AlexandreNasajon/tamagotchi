--[[
    Tamagotchi by nasa

    TODO
    
    FARM
    
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
    miniFont = love.graphics.newFont(16)
    if not time then time = 0 end
    animationCounter = 0
    hungerCounter = 0
    boredomCounter = 0
    screenSize = love.window.setMode( 9*40 , 16*40 )
    backgroundColor = {189/255 , 195/255 , 199/255} -- lilás bem claro
    love.graphics.setBackgroundColor( backgroundColor )
    love.graphics.setColor( 0 , 0 , 0 )
    titleBox = {box = {x = 9*12 , y = 16}}
    optionBox = {}
    optionBox[1] = {box = {x = 9*12 , y = 16*20 , w = 140 , h = 40}}
    optionBox[2] = {box = {x = 9*12 , y = 16*24 , w = 140 , h = 40}}
    optionBox[3] = {box = {x = 9*12 , y = 16*28 , w = 140 , h = 40}}
    optionBox[4] = {box = {x = 9*12 , y = 16*32 , w = 140 , h = 40}}
    optionBox[5] = {box = {x = 9*12 , y = 16*36 , w = 140 , h = 40}}

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
    pet3 = {
        name = 'Guz',
        strength = 1,
        stamina = 5,
        carisma = 0,
        img = love.graphics.newImage( "images/pet3.png" ),
        miniImg = love.graphics.newImage( 'images/pet3mini.png')
    }

    mainPetBox = {pet = pet1 , box = {x = 9*12 , y = 16*4 }}

    farmBox = {
    {pet = pet2 , box = {x = 9*2 , y = 16*8 , w = 50 , h = 50}},
    {pet = pet3 , box = {x = 9*2 , y = 16*13 , w = 50 , h = 50}},
    {box = {x = 9*2 , y = 16*17 , w = 50 , h = 50}}
    }

    selectionBox = {
        {box = {x = 9*4 , y = 16*8, w = 50 , h = 50}},
        {box = {x = 9*10 , y = 16*8, w = 50 , h = 50}},
        {box = {x = 9*18 , y = 16*8, w = 50 , h = 50}},
        {box = {x = 9*24 , y = 16*8, w = 50 , h = 50}},
        {box = {x = 9*30 , y = 16*8, w = 50 , h = 50}}
    }

    teamBox = {
        {box = {x = 9*4 , y = 16*32, w = 50 , h = 50}},
        {box = {x = 9*10 , y = 16*32, w = 50 , h = 50}},
        {box = {x = 9*18 , y = 16*32, w = 50 , h = 50}}
    }

    explorerBox = {
        {box = {x = 9*4 , y = 16*32, w = 50 , h = 50}},
        {box = {x = 9*10 , y = 16*32, w = 50 , h = 50}},
        {box = {x = 9*18 , y = 16*32, w = 50 , h = 50}}
    }

    enemyBox = {
        {box = {x = 9*22 , y = 16*28, w = 50 , h = 50}},
    }

    atMenu = true


    loadGame()
end

function drawMainPetBox(x,y)
    love.graphics.draw( mainPetBox.pet.miniImg , x , y )
    love.graphics.draw( love.graphics.newText(miniFont,mainPetBox.pet.name) , 9*2 + x , y - 16 )
end

function drawPetBox(x,y)
    for i = 1 , #farmBox do
        if farmBox[i].pet then 
            love.graphics.draw( farmBox[i].pet.miniImg , farmBox[i].box.x + x , farmBox[i].box.y + y)
            love.graphics.draw( love.graphics.newText(miniFont,farmBox[i].pet.name) , farmBox[i].box.x + 9*2 + x , farmBox[i].box.y - 16 + y )
        end
    end
end

function love.update(dt)
    saveGame()
    time = time + 1/60
    if atForest then
        
    end
end

function love.draw()
    if atMenu then

        love.graphics.draw(love.graphics.newText( font , 'MAIN MENU' ) , titleBox.box.x , titleBox.box.y )
        love.graphics.draw(love.graphics.newText( font , '> CONTINUE' ) , optionBox[1].box.x , optionBox[1].box.y)
        love.graphics.draw(love.graphics.newText( font , '> NEW GAME' ), optionBox[2].box.x , optionBox[2].box.y)

    elseif atFarm then

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
        drawPetBox(0,0)
        love.graphics.draw(love.graphics.newText( font , '> ADVENTURE' ) , optionBox[4].box.x , optionBox[4].box.y )

    elseif atDungeonSelectionScreen then

        love.graphics.draw(love.graphics.newText( font , 'ADVENTURE' ) , titleBox.box.x , titleBox.box.y  )
        love.graphics.draw(love.graphics.newText( font , '> FOREST') , optionBox[1].box.x , optionBox[1].box.y )

    elseif atTeamSelectionScreen then

        love.graphics.draw(love.graphics.newText( font , 'SELECT YOUR TEAM' ) , titleBox.box.x - 9*4 , titleBox.box.y  )
        for i = 1 , #selectionBox do
            if selectionBox[i].pet then
                love.graphics.draw( selectionBox[i].pet.miniImg , selectionBox[i].box.x , selectionBox[i].box.y )
            end
        end
        love.graphics.draw(love.graphics.newText(font , '> CONFIRM TEAM') , optionBox[3].box.x , optionBox[3].box.y)
        for i = 1 , #teamBox do
            if teamBox[i].pet then
                love.graphics.draw( teamBox[i].pet.miniImg , teamBox[i].box.x , teamBox[i].box.y )
            end
        end

    elseif atForest then

        love.graphics.draw(love.graphics.newText( font , 'FOREST' ) , titleBox.box.x , titleBox.box.y  )
        love.graphics.draw( Adventure.Dungeons.Forest.img , -9*4 , 16*4 )
        for i = 1 , #explorerBox do
            if explorerBox[i].pet then
                love.graphics.draw(love.graphics.newText( miniFont , explorerBox[i].pet.name ) , explorerBox[i].box.x -9*2, explorerBox[i].box.y - 16)
                love.graphics.draw(explorerBox[i].pet.miniImg , explorerBox[i].box.x -9*4 , explorerBox[i].box.y )
            end
        end
        if enemyBox.pet then
            love.graphics.draw(love.graphics.newText( miniFont , enemyBox.pet.name ) , enemyBox[1].box.x + 9*8 , enemyBox[1].box.y )
            love.graphics.draw(enemyBox.pet.img , enemyBox[1].box.x , enemyBox[1].box.y )
        end
    end
end

function MenuScreen( x , y , button , istouch )
    if button == 1 then
        if inBox( x , y , optionBox[1].box) then -- continue
            atMenu = false
            atFarm = true
        elseif inBox( x , y , optionBox[2].box) then -- new game
            time = 0
            atMenu = false
            atFarm = true
        end
    end
end

function FarmScreen( x , y , button , istouch )
    if button == 1 then
        if inBox(x,y,optionBox[4].box) then
            atFarm = false
            atDungeonSelectionScreen = true
        end
        for i = 1 , #farmBox do
            if inBox(x,y,farmBox[i].box) then
                local tmp = farmBox[i].pet
                farmBox[i].pet = mainPetBox.pet
                mainPetBox.pet = tmp
                tmp = nil
            end
        end
    end
end

function dungeonSelectionScreen( x , y , button , istouch )
    if button == 1 then
        if inBox(x,y,optionBox[1].box) then
            selectionBox[1].pet = mainPetBox.pet
            if farmBox[1].pet then selectionBox[2].pet = farmBox[1].pet end
            if farmBox[2].pet then selectionBox[3].pet = farmBox[2].pet end 
            if farmBox[3].pet then selectionBox[4].pet = farmBox[3].pet end
            atDungeonSelectionScreen = false
            atTeamSelectionScreen = true
        end
    end
end

function teamSelectionScreen( x , y , button , istouch )
    if button == 1 then
        if inBox(x,y,optionBox[3].box) then
            if teamBox[1].pet then -- check if there is any pet selected
                enemyBox.pet = Adventure.Dungeons.Forest.enemies[1]
                atTeamSelectionScreen = false
                atForest = true
            end
        end
        for j = 1 , #selectionBox do
            if inBox(x,y,selectionBox[j].box) then
                if not teamBox[1].pet then
                    teamBox[1].pet = selectionBox[j].pet
                    explorerBox[1].pet = teamBox[1].pet
                    selectionBox[j].pet = nil
                elseif not teamBox[2].pet then
                    teamBox[2].pet = selectionBox[j].pet
                    explorerBox[2].pet = teamBox[2].pet
                    selectionBox[j].pet = nil
                elseif not teamBox[3].pet then
                    teamBox[3].pet = selectionBox[j].pet
                    explorerBox[3].pet = teamBox[3].pet
                    selectionBox[j].pet = nil
                end
            end
        end
    end
end

function ForestScreen()
    enemyBox.pet = Adventure.Dungeons.Forest.enemies[1]
end

function love.mousepressed( x , y , button , istouch )
    if atMenu then
        MenuScreen( x , y , button , istouch )
    elseif atFarm then
        FarmScreen( x , y , button , istouch )
    elseif atDungeonSelectionScreen then
        dungeonSelectionScreen( x , y , button , istouch )
    elseif atTeamSelectionScreen then
        teamSelectionScreen( x , y , button , istouch )
    elseif atForest then
        ForestScreen()
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
