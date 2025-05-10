-- savesystem.lua

function saveToFile(arguments, filepath)
    local wins = arguments[1]
    local loses = arguments[2]
    local WIN, LOSES

    -- Abre o Arquivo para o modo lER
    local file = io.open(filepath, "r")

    -- Cria um Arquivo se Não Existir
    if file == nil then
        -- Abre para o Modo ESCREVER
        file = io.open(filepath, "w")
        if file ~= nil then
            file:write("0\n0\n")  
            file:close()         
            -- Reabre para o Modo LER
            file = io.open(filepath, "r")
        end
    end

    -- Escreve as Vitórias e Derrotas
    if file then
        WIN = tonumber(file:read("*line")) or 0 
        LOSES = tonumber(file:read("*line")) or 0
        file:close() 
    end

    file = io.open(filepath, "w")
    if file then
        -- Atualiza os Valores
        WIN = WIN + wins
        LOSES = LOSES + loses

        file:write(WIN .. "\n")
        file:write(LOSES .. "\n")
        file:close()
    else
        print("ERRO!, não pode abrir arquivo!")
    end
end
