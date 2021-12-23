addSearchPath(moduleDirectory .. "/Custom Module/FLT_SYS/F_CTL/SPLR")

FCTL.SPLR = {}

components = {
    SPLR_STAT {},
    SPLR_ACT  {},
    SPDBRK_STAT {},
    SPLR_CTL  {},
}

function update()
    updateAll(components)
end