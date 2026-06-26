--全域設定
tileSize = 64    --小方格大小
boardWidth = 10  --地圖寬
boardHeight = 18 --地圖高
dropTimer = 0    --目前累積掉落時間
dropDelay = 1    ----每1秒掉一格
sidePanelWidth = 200
windowWidth = boardWidth * tileSize + sidePanelWidth
windowHeight = boardHeight * tileSize + tileSize

--方塊座標
shapes = {
    L = {
        { x = 0, y = 0 },
        { x = 0, y = 1 },
        { x = 0, y = 2 },
        { x = 1, y = 2 },
    },
    T = {
        { x = 0, y = 0 },
        { x = 1, y = 0 },
        { x = 2, y = 0 },
        { x = 1, y = 1 }
    },
    I = {
        { x = 0, y = 0 },
        { x = 1, y = 0 },
        { x = 2, y = 0 },
        { x = 3, y = 0 }
    },
    O = {
        { x = 0, y = 0 },
        { x = 1, y = 0 },
        { x = 0, y = 1 },
        { x = 1, y = 1 }
    }
}

--建立地圖表格
board = {}                   --建立空白地圖

for y = 1, boardHeight do    --延伸y列(從第1列建立到第20列)
    board[y] = {}            --建立第y列
    for x = 1, boardWidth do --在y上進行x的延伸(在這一列建立第1欄到第10欄)
        board[y][x] = 0      --建立空格
    end
end

--移動
function love.keypressed(key)
    if key == "a" then
        if canMove(currentShape, pieceX - 1, pieceY) then
            pieceX = pieceX - 1
        end
    elseif key == "d" then
        if canMove(currentShape, pieceX + 1, pieceY) then
            pieceX = pieceX + 1
        end
    elseif key == "space" then
        if canMove(currentShape, pieceX, pieceY + 1) then
            pieceY = pieceY + 1
        end
    elseif key == "q" then
        local rotated = rotateLeft(currentShape)
        if canMove(rotated, pieceX, pieceY) then
            currentShape = rotated
        end
    elseif key == "e" then
        local rotated = rotateRight(currentShape)

        if canMove(rotated, pieceX, pieceY) then
            currentShape = rotated
        end
    end
end

--碰撞判斷
function canMove(shape, posX, posY)     --建立canMove功能用於確認方塊是否可以移動新的位置
    for _, block in ipairs(shape) do    --輪詢 shape 每一個組成方塊(block)
        local x = posX + block.x        -- 計算方塊預期移動後的 x 位置(計算此小方塊移動後的實際 X 座標
        local y = posY + block.y        -- 計算方塊預期移動後的 y 位置

        if x < 1 or x > boardWidth then --判斷x是否超出地圖左右邊界
            return false
        end

        if y > boardHeight then --判斷y是否超出地圖底部
            return false
        end

        if board[y] and board[y][x] == 1 then --判斷地圖中的x y 座標是否已有固定方塊
            return false
        end
    end

    return true
end

--方塊旋轉計算
function rotateLeft(shape)--將方塊旋轉並且回傳新形狀
    local newShape = {}--放入新方塊座標的空格

    for _, block in ipairs(shape) do
        table.insert(newShape, {--把新座標塞入newshape
            x = block.y,--新x=舊y
            y = -block.x--新y-舊-x
        })
    end

    return newShape--回傳旋轉後座標
end

function rotateRight(shape)
    local newShape = {}

    for _, block in ipairs(shape) do
        table.insert(newShape, {
            x = -block.y,
            y = block.x
        })
    end

    return newShape
end

--方塊固定
function lockPiece()                        --建立固定方塊功能
    for _, block in ipairs(currentShape) do --一個取出目前形狀每個小格的循環
        local x = pieceX + block.x          --目前方塊位置 + 小方塊偏移量 = 實際x座標
        local y = pieceY + block.y          --目前方塊位置 + 小方塊偏移量 = 實際y座標

        board[y][x] = 1                     --將x y標記方格占用
    end
end

--滿排刪除
function clearLines()
    for y = boardHeight, 1, -1 do--由下往上檢查
        local full = true--假設某y填滿

        for x = 1, boardWidth do--檢查y排每一欄
            if board[y][x] == 0 then--如果這排0=未填滿
                full = false--標記為不符合條件
                break--停止檢查
            end
        end

        if full then--如果填滿成立
            table.remove(board, y)--刪除這一整排

            local newRow = {}--建立一個新的空白列
            for x = 1, boardWidth do--把新空白烈都設為0
                newRow[x] = 0
            end

            table.insert(board, 1, newRow)--將新列插入到最上層
        end
    end
end

--新方塊生成
function spawnPiece() --建立新的隨機方塊
    local types = {   --可生成的方塊種類
        shapes.L,
        shapes.T,
        shapes.I,
        shapes.O
    }

    currentShape = types[math.random(#types)]                     -- 隨機取得一個方塊形狀#types/ = types內元素數量/math.random() = 隨機產生編號/types[編號] = 取出對應方塊


    pieceX = 5 --新方塊生成的X位置
    pieceY = 1 --新方塊生成的Y位置
end

--畫出指定方格
function drawPiece(shape, posX, posY)                 --畫圖(指定圖案)
    for _, block in ipairs(shape) do                  --依序取出形狀中的每個小方塊
        local drawX = (posX + block.x - 1) *tileSize  --要畫出方塊的x位子=(方塊的x+小方格的x-1)*它的大小  將格子座標轉換成螢幕像素座標/ -1是因為格子從1開始，而像素從0開始

        local drawY = (posY + block.y - 1) * tileSize --同上

        love.graphics.draw(blockImage, drawX, drawY)  --將 blockImage 畫到(drawX, drawY)
    end
end

function love.load()                               --初始化(圖 分數-0 音樂 第一個方塊都屬於)
    love.window.setMode(windowWidth, windowHeight)
    blockImage = love.graphics.newImage("1x1.png") --載入方塊圖片
    spawnPiece()                                   --生成第一個方塊
end

--時間流動
function love.update(dt)                                  --每幀進行一次
    dropTimer = dropTimer + dt                            --目前累積掉落時間=累積時間+變化時間
    if dropTimer >= dropDelay then                        --如果時間累積到1秒
        dropTimer = 0                                     --計時器歸零
        if canMove(currentShape, pieceX, pieceY + 1) then --如果目前方塊可向下移動一格
            pieceY = pieceY + 1                           --目前方塊往y軸+1格
        else                                              --如果無法移動
            lockPiece()   --固定目前方塊到地圖
            clearLines()--刪除滿排
            spawnPiece()                                  --生成新方塊
        end
    end
end

--畫出地圖
function drawBoard()
    for y = 1, boardHeight do           --檢查y列
        for x = 1, boardWidth do        --檢查x欄
            if board[y][x] == 1 then    --判斷這格是否存在方塊
                love.graphics.draw(     --畫圖
                    blockImage,         --我的1x1.png
                    (x - 1) * tileSize, --計算x
                    (y - 1) * tileSize  --計算y
                )
            end
        end
    end
end

--畫圖功能
function love.draw()                        --每幀呼叫一次，負責繪製畫面
    drawBoard()                             --畫出固定方塊
    drawPiece(currentShape, pieceX, pieceY) --將目前方塊畫到畫面上
end
