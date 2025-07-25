package game

import "core:c"
import rl "vendor:raylib"

run: bool
texture: rl.Texture
texture2: rl.Texture
texture2_rot: f32
render_texture: rl.RenderTexture

GAME_NAME :: "Cool game"
SCREEN_WIDTH :: 480
SCREEN_HEIGHT :: 360
WINDOW_WIDTH: i32
WINDOW_HEIGHT: i32

// Called once on app startup
init :: proc() {
	run = true
	WINDOW_WIDTH = 1600
	WINDOW_HEIGHT = 900
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, GAME_NAME)
	render_texture = rl.LoadRenderTexture(WINDOW_WIDTH, WINDOW_HEIGHT)

	// Anything in `assets` folder is available to load.

}

// Draws game world to our render_texture
render_scene :: proc() {
	rl.BeginTextureMode(render_texture)
	// Draw objects here
	rl.DrawCircleV({0, 0}, 800, rl.BLUE)
	rl.ClearBackground(rl.RED)
	rl.EndTextureMode()
}

update :: proc() {
	render_scene()
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	// Draw the render texture to the screen
	rl.DrawTexturePro(
		render_texture.texture,
		{0, 0, SCREEN_WIDTH, SCREEN_HEIGHT},
		{0, 0, f32(WINDOW_WIDTH), f32(WINDOW_HEIGHT)},
		{0, 0},
		0,
		rl.WHITE,
	)
	rl.EndDrawing()

	// Free up the memory allocated by the temp allocator
	free_all(context.temp_allocator)
}

// In a web build, this is called when browser changes size
parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(c.int(w), c.int(h))
}

// Called when the app is closed
shutdown :: proc() {
	rl.CloseWindow()
}

should_run :: proc() -> bool {
	when ODIN_OS != .JS {
		// Never run this proc in browser. It contains a 16 ms sleep on web!
		if rl.WindowShouldClose() {
			run = false
		}
	}

	return run
}
