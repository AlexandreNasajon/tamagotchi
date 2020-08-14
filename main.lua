--[[
    Tamagotchi by nasa
   
    - recrutar inimigo
]]

local Farm = require('Farm')
local Items = require('Items')
local Equip = require('Equip')
local Monsters = require('Monsters')
local Adventure = require('Adventure')
local Shop = require('Shop')

function find( where ,what )
    for k,v in pairs(where) do
        if v == what then
        return k
        end
    end
end

function move( what , origin , destiny )
    destiny[#destiny+1] = what
    local j = find( origin , what )
    if j then
        while j <= #origin do
            origin[j] = origin[j+1]
            j = j+1
        end
    else print('J is NIL') -- debugger
    end
end

function eliminate( what , where )
    local pit = {}
    move( what , where , pit)
    pit = nil
end


-- checa se o player clicou dentro do objeto
function inBox( x , y , obj )
    if x >= obj.x and x <= obj.x + obj.w and y >= obj.y and y <= obj.y + obj.h then
        return true
    end
end

function love.load()
    font = love.graphics.newFont(24)
    miniFont = love.graphics.newFont(14)
    if not time then time = 0 end
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
        gems = 0,
        rank = 'Copper',
        inventory = {},
        pets = {
            Monsters.Jer:new(),
            Monsters.Bel:new(),
            Monsters.Guz:new(),
            Monsters.Jer:new()
        }
    }

    mainPetBox = {pet = player.pets[1] , box = {x = 9*12 , y = 16*4 }}

    farmBox = {
    {pet = player.pets[2] , box = {x = 9*30 , y = 16*5 , w = 50 , h = 50}},
    {pet = player.pets[3] , box = {x = 9*30 , y = 16*10 , w = 50 , h = 50}},
    {pet = player.pets[4] , box = {x = 9*30 , y = 16*17 , w = 50 , h = 50}}
    }

    inventoryBox = {
        {box = {x = 9*2 , y = 16*15, w = 50 , h = 50}},
        {box = {x = 9*12 , y = 16*15, w = 50 , h = 50}},
        {box = {x = 9*22 , y = 16*15, w = 50 , h = 50}},
        {box = {x = 9*32 , y = 16*15, w = 50 , h = 50}},
        
        {box = {x = 9*2 , y = 16*20, w = 50 , h = 50}},
        {box = {x = 9*12 , y = 16*20, w = 50 , h = 50}},
        {box = {x = 9*22 , y = 16*20, w = 50 , h = 50}},
        {box = {x = 9*32 , y = 16*20, w = 50 , h = 50}},

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
        {box = {x = 9*18 , y = 16*22, w = 50 , h = 50}},
        {box = {x = 9*12 , y = 16*24, w = 50 , h = 50}},
        {box = {x = 9*26 , y = 16*24, w = 50 , h = 50}}
    }

    enemyBox = {
        {box = {x = 9*10 , y = 16*6, w = 50 , h = 50}},
    }

    shopBox = {
        {Shop.catalog[1] ,  box = {x = 9*4 , y = 16*8, w = 50 , h = 50}},
        {Shop.catalog[2] ,  box = {x = 9*4 , y = 16*14, w = 50 , h = 50}},
        {Shop.catalog[3] ,  box = {x = 9*4 , y = 16*20, w = 50 , h = 50}},
        {Shop.catalog[4] ,  box = {x = 9*4 , y = 16*26, w = 50 , h = 50}},
        {box = {x = 9*8 , y = 16*32 , w = 140 , h = 40}}
    }

    animationCounter = 0
    
    screen = 'menu'

end

function love.update(dt)
    --saveGame()
    time = time + 1/60

    if enemyBox.pet then
        if enemyBox.pet.animationBox.y > 16*24 then
            enemyBox.pet.animationBox.y = enemyBox.pet.animationBox.y -1
        else
            enemyBox.pet.animationBox.y = -100
        end
    end

    if explorerBox[1].pet then
        if explorerBox[1].pet.animationBox.y > 16*24 then
            explorerBox[1].pet.animationBox.y = explorerBox[1].pet.animationBox.y -1
        else
            explorerBox[1].pet.animationBox.y = -100
        end
    end

end

function drawMenu()
    love.graphics.draw(love.graphics.newText( font , 'MAIN MENU' ) , titleBox.box.x , titleBox.box.y )
    love.graphics.draw(love.graphics.newText( font , '> CONTINUE' ) , optionBox[1].box.x , optionBox[1].box.y)
    love.graphics.draw(love.graphics.newText( font , '> NEW GAME' ), optionBox[2].box.x , optionBox[2].box.y)
end

function MenuScreen( x , y , button , istouch )
    if button == 1 then
        if inBox( x , y , optionBox[1].box) then -- continue
            screen = 'farm'
        elseif inBox( x , y , optionBox[2].box) then -- new game
            time = 0
            screen = 'farm'
        end
    end
end

function drawMainPetBox(x,y)
    love.graphics.draw( player.pets[1].miniImg , x , y )
    love.graphics.draw( love.graphics.newText(miniFont,player.pets[1].name) , 9*2 + x , y - 16 )
end

function drawPetBox(x,y)
    for i = 2 , #player.pets do
        if player.pets[i] then 
            love.graphics.draw( farmBox[i-1].pet.miniImg , farmBox[i-1].box.x + x , farmBox[i-1].box.y + y)
            love.graphics.draw( love.graphics.newText(miniFont,player.pets.name) , farmBox[i-1].box.x + 9*2 + x , farmBox[i-1].box.y - 16 + y )
        end
    end
end

function drawInventoryBox(x,y)
    for i = 1 , #player.inventory do
        if player.inventory[i] then
            love.graphics.draw( player.inventory[i].img , inventoryBox[i].box.x , inventoryBox[i].box.y )
            love.graphics.draw( love.graphics.newText(miniFont,player.inventory[i].name) , inventoryBox[i].box.x -9, inventoryBox[i].box.y - 16)
        end
    end
end

function drawFarm()
    love.graphics.draw(love.graphics.newText( font , '     FARM' ) , titleBox.box.x , titleBox.box.y  )
    love.graphics.draw( love.graphics.newImage('images/farm.png') , 0 , 16 )
    love.graphics.print('Creature: '..mainPetBox.pet.name , 0 , 16)
    love.graphics.print('Health: '..mainPetBox.pet.health , 0 , 16*2)
    love.graphics.print('Strength: '..mainPetBox.pet.strength , 0 , 16*3)
    love.graphics.print('Speed: '..mainPetBox.pet.speed , 0 , 16*4)
    love.graphics.print('Carisma: '..mainPetBox.pet.carisma , 0 , 16*5)
    love.graphics.print('Intelect: '..mainPetBox.pet.intelect , 0 , 16*6)
    love.graphics.print('Stamina: '..mainPetBox.pet.stamina , 0 , 16*7)
    love.graphics.print('Coins: '..player.coins , 9*12 , 0)
    love.graphics.print('Gems: '..player.gems , 9*20 , 0)
    love.graphics.print('Rank: '..player.rank , 9*28 , 0)
    drawInventoryBox(9*12,16*18)
    love.graphics.draw( mainPetBox.pet.img , mainPetBox.box.x , mainPetBox.box.y )
    drawPetBox(0,0)
    love.graphics.draw(love.graphics.newText( font , '> ADVENTURE' ) , optionBox[2].box.x , optionBox[2].box.y )
    love.graphics.draw(love.graphics.newText( font , '> SHOP' ) , optionBox[3].box.x , optionBox[3].box.y )
end

function FarmScreen( x , y , button , istouch )
    if button == 1 then
        if inBox(x,y,optionBox[2].box) then
            screen = 'dungeon selection'
        elseif inBox(x,y,optionBox[3].box) then
            screen = 'shop'
        end
        for i = 1 , #farmBox do
            if inBox(x,y,farmBox[i].box) then
                local tmp = mainPetBox.pet
                mainPetBox.pet = farmBox[i].pet
                farmBox[i].pet = tmp
                tmp = nil
            end
        end
        for i = 1 , #player.inventory do
            if inBox(x,y,inventoryBox[i].box) then
                player.inventory[i].effect(mainPetBox.pet)
                eliminate(player.inventory[i],player.inventory)
            end
        end
    end
end

function drawTeamSelection()
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
end

function teamSelectionScreen( x , y , button , istouch )
    if button == 1 then
        if inBox(x,y,optionBox[3].box) then
            if teamBox[1].pet then -- check if there is any pet selected
                enemyBox.pet = Adventure.Dungeons.Forest.enemies[1]
                screen = 'forest'
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



function dungeonSelectionScreen( x , y , button , istouch )
    if button == 1 then
        if inBox(x,y,optionBox[1].box) then
            selectionBox[1].pet = mainPetBox.pet
            if farmBox[1].pet then selectionBox[2].pet = farmBox[1].pet end
            if farmBox[2].pet then selectionBox[3].pet = farmBox[2].pet end 
            if farmBox[3].pet then selectionBox[4].pet = farmBox[3].pet end
            screen = 'team selection'
        end
    end
end


function drawForest()
    love.graphics.draw(love.graphics.newText( font , 'FOREST' ) , titleBox.box.x , titleBox.box.y  )
    love.graphics.draw( Adventure.Dungeons.Forest.img , -9*8 , 16 )
    for i = 1 , #explorerBox do
        if explorerBox[i].pet and explorerBox[i].pet.health > 0 then
            love.graphics.draw(love.graphics.newText( miniFont , explorerBox[i].pet.name ) , explorerBox[i].box.x -9*2, explorerBox[i].box.y - 16)
            love.graphics.draw(explorerBox[i].pet.miniImg , explorerBox[i].box.x -9*4 , explorerBox[i].box.y )
            love.graphics.draw(love.graphics.newText( miniFont , 'HP: '..explorerBox[i].pet.health ) , explorerBox[i].box.x -9*3, explorerBox[i].box.y + 16*4)
            love.graphics.draw( love.graphics.newText( font , explorerBox[i].pet.animationBox.dmg ) , explorerBox[i].pet.animationBox.x , explorerBox[i].pet.animationBox.y )
        end
    end
    if enemyBox.pet.health > 0 then
        love.graphics.draw(love.graphics.newText( miniFont , enemyBox.pet.name ) , enemyBox[1].box.x + 9*8 , enemyBox[1].box.y )
        love.graphics.draw(enemyBox.pet.img , enemyBox[1].box.x , enemyBox[1].box.y )
        love.graphics.draw(love.graphics.newText( miniFont , 'HP: '..enemyBox.pet.health ) , enemyBox[1].box.x + 9*7 , enemyBox[1].box.y + 16*8 )
        love.graphics.draw( love.graphics.newText( font , enemyBox.pet.animationBox.dmg ) , enemyBox.pet.animationBox.x , enemyBox.pet.animationBox.y )
    end
end

function ForestScreen()
    -- combate
    -- cada click passa pro próximo turno

    -- tira os bichos da box de seleção do time pra não bugar quando for selecionar de novo
    for i = 1 , #teamBox do
        teamBox[i].pet = nil
    end

    if enemyBox.pet.health > 0 then
        enemyBox.pet.health = enemyBox.pet.health - explorerBox[1].pet.strength
        enemyBox.pet.animationBox.dmg = - explorerBox[1].pet.strength
        enemyBox.pet.animationBox.x = enemyBox[1].box.x + 9*7
        enemyBox.pet.animationBox.y = enemyBox[1].box.y
    else
        enemyBox.pet.health = enemyBox.pet.maxHealth
        player.pets[1].health = player.pets[1].maxHealth
        for i = 1 , #player.pets do if player.pets[i] then player.pets[i].health = player.pets[i].maxHealth end end
        for i = 1 , 3 do explorerBox[i].pet = nil end
        screen = 'farm'
    end
        
    if explorerBox[1].pet and explorerBox[1].pet.health > 0 then
        explorerBox[1].pet.health = explorerBox[1].pet.health - enemyBox.pet.strength
        explorerBox[1].pet.animationBox.dmg = - enemyBox.pet.strength
        explorerBox[1].pet.animationBox.x = explorerBox[1].box.x - 9*2
        explorerBox[1].pet.animationBox.y = explorerBox[1].box.y - 16
    elseif explorerBox[2].pet then
        if explorerBox[2].pet.health > 0 then
            explorerBox[1].pet = explorerBox[2].pet
            explorerBox[1].pet.health = explorerBox[1].pet.health - enemyBox.pet.strength
            explorerBox[1].pet.animationBox.dmg = - enemyBox.pet.strength
            explorerBox[1].pet.animationBox.x = explorerBox[1].box.x - 9*2
            explorerBox[1].pet.animationBox.y = explorerBox[1].box.y - 16
            if explorerBox[3].pet then 
                explorerBox[2].pet = explorerBox[3].pet
                explorerBox[3].pet = nil
            else
                explorerBox[2].pet = nil
            end
        end 
    else
        enemyBox.pet.health = enemyBox.pet.maxHealth
        for i = 1 , #player.pets do if player.pets[i] then player.pets[i].health = player.pets[i].maxHealth end end
        for i = 1 , 3 do explorerBox[i].pet = nil end
        screen = 'farm'
    end
end

function drawShop()
    love.graphics.print('Coins: '..player.coins , 9*12 , 0)
    love.graphics.print('Gems: '..player.gems , 9*20 , 0)
    love.graphics.print('Rank: '..player.rank , 9*28 , 0)
    love.graphics.draw(love.graphics.newText( font , 'SHOP' ) , titleBox.box.x , titleBox.box.y  )
    for i = 1 , 4 do
        love.graphics.draw( love.graphics.newText( miniFont , shopBox[i][1].name) , shopBox[i].box.x , shopBox[i].box.y - 16)
        love.graphics.draw( shopBox[i][1].img , shopBox[i].box.x , shopBox[i].box.y )
        love.graphics.draw( love.graphics.newText( miniFont , 'Cost: '..shopBox[i][1].cost) , shopBox[i].box.x + 9*8 , shopBox[i].box.y + 16)
        love.graphics.draw( love.graphics.newText( miniFont , shopBox[i][1].text) , shopBox[i].box.x + 9*8 , shopBox[i].box.y + 16*2)
    end
    love.graphics.draw(love.graphics.newText( font , '> FARM' ) , shopBox[5].box.x , shopBox[5].box.y  )
end

function ShopScreen( x , y , button , istouch )
    if button == 1 then
        if inBox(x,y,shopBox[5].box) then
            screen = 'farm'
        end
        for i = 1 , 4 do
            if inBox(x,y,shopBox[i].box) then
                if player.coins >= shopBox[i][1].cost and #player.inventory < 8 then
                    player.coins = player.coins - shopBox[i][1].cost
                    player.inventory[#player.inventory +1] = shopBox[i][1]
                end
            end
        end
    end
end

function love.draw()
    love.graphics.print(math.floor(time))
    if screen == 'menu' then
        drawMenu()
    elseif screen == 'farm' then
        drawFarm()
    elseif screen == 'dungeon selection' then
        love.graphics.draw(love.graphics.newText( font , 'ADVENTURE' ) , titleBox.box.x , titleBox.box.y  )
        love.graphics.draw(love.graphics.newText( font , '> FOREST') , optionBox[1].box.x , optionBox[1].box.y )
    elseif screen == 'team selection' then
        drawTeamSelection()
    elseif screen == 'forest' then
        drawForest()
    elseif screen == 'shop' then
        drawShop()
    end
end

function love.mousepressed( x , y , button , istouch )
    if screen == 'menu' then
        MenuScreen( x , y , button , istouch )
    elseif screen == 'farm' then
        FarmScreen( x , y , button , istouch )
    elseif screen == 'dungeon selection' then
        dungeonSelectionScreen( x , y , button , istouch )
    elseif screen == 'team selection' then
        teamSelectionScreen( x , y , button , istouch )
    elseif screen == 'forest' then
        ForestScreen() -- tirar do mousepressed
    elseif screen == 'shop' then
        ShopScreen( x , y , button , istouch )
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
    player.pets[1].name = fileLine(1,'file.txt')
    player.pets[1].strength = tonumber(fileLine(2,'file.txt'))
    player.pets[1].stamina = tonumber(fileLine(3,'file.txt'))
    player.pets[1].carisma = tonumber(fileLine(4,'file.txt'))
    time = tonumber(fileLine(5,'file.txt'))
    player.coins = tonumber(fileLine(6,'file.txt'))
    player.gems = tonumber(fileLine(7,'file.txt')) 
    player.rank = fileLine(8,'file.txt')
end

-- substitui cada linha do arquivo pelo que estiver nas variáveis do pet
function saveGame()
    local file = io.open('file.txt','w')
    file:write(player.pets[1].name, "\n")
    file:write(player.pets[1].strength, "\n")
    file:write(player.pets[1].stamina, "\n")
    file:write(player.pets[1].carisma, "\n")
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
    --[[
        quando player fechar a janela, guarda o horário e a data pra calcular o tempo

        os.time() => 1476852730 -- seconds since epoch
        os.date("%X", os.time()) => 00:50:02
        os.date("%c", os.time()) => "Wed Oct 19 00:50:02 2016"

    ]]
    print("Thanks for playing! Come back soon!")
end
