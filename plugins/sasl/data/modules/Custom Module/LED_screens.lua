addSearchPath(moduleDirectory .. "/Custom Module/LED_subcomponents/")

components = {
    bat_1 {},
    bat_2 {},
    l_qnh {},
    r_qnh {},
    rud_trim {},
}

function update()
    updateAll(components)
end

function draw()
    drawAll(components)
end