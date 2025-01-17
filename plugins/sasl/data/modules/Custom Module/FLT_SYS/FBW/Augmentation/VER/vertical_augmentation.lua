function update()
    FBW.vertical.protections.General.Pitch.UP_LIM()
    FBW.vertical.protections.General.AoA.COMPUTE_SP(get(Total_input_pitch))
    FBW.vertical.controllers.Rotation_PID.bumpless_transfer()
    FBW.vertical.controllers.Rotation_PID.control()
    FBW.vertical.controllers.Rotation_PID.bp()
    FBW.vertical.controllers.Flight_PID.gain_scheduling()
    FBW.vertical.controllers.Flight_PID.bumpless_transfer()
    FBW.vertical.controllers.Flight_PID.control()
    FBW.vertical.controllers.Flight_PID.bp()
    FBW.vertical.controllers.Flare_PID.bumpless_transfer()
    FBW.vertical.controllers.Flare_PID.control()
    FBW.vertical.controllers.Flare_PID.bp()
    FBW.vertical.controllers.AUTOTRIM_PID.bumpless_transfer()
    FBW.vertical.controllers.AUTOTRIM_PID.control()
    FBW.vertical.controllers.AUTOTRIM_PID.bp()
    FBW.vertical.controllers.output_blending()
end
