#ifndef CROSSHAIR_ENGINE_H
#define CROSSHAIR_ENGINE_H

#include <cstdint>

// Define extern "C" for C++ compilers to avoid name mangling
#ifdef __cplusplus
extern "C" {
#endif

/**
 * Initializes the crosshair engine.
 * Must be called before any other function in the engine.
 * 
 * @return 1 on success, 0 on failure
 */
int32_t initialize();

/**
 * Renders a crosshair using the native engine.
 * 
 * @param shape_index The index of the crosshair shape (0=dot, 1=cross, 2=circle, etc.)
 * @param color_value The ARGB color value of the crosshair
 * @param size The size of the crosshair in pixels
 * @param thickness The thickness of the crosshair lines in pixels
 * @param opacity The opacity of the crosshair (0.0 to 1.0)
 * 
 * @return 1 on success, 0 on failure
 */
int32_t renderCrosshair(int32_t shape_index, uint32_t color_value, double size, double thickness, double opacity);

/**
 * Exports a crosshair as a PNG image.
 * 
 * @param shape_index The index of the crosshair shape
 * @param color_value The ARGB color value of the crosshair
 * @param size The size of the crosshair in pixels
 * @param thickness The thickness of the crosshair lines in pixels
 * @param opacity The opacity of the crosshair
 * @param output_path The path where the PNG file will be saved
 * 
 * @return 1 on success, 0 on failure
 */
int32_t exportCrosshairAsPng(int32_t shape_index, uint32_t color_value, double size, double thickness, double opacity, const char* output_path);

/**
 * Exports a crosshair as an SVG image.
 * 
 * @param shape_index The index of the crosshair shape
 * @param color_value The ARGB color value of the crosshair
 * @param size The size of the crosshair in pixels
 * @param thickness The thickness of the crosshair lines in pixels
 * @param opacity The opacity of the crosshair
 * @param output_path The path where the SVG file will be saved
 * 
 * @return 1 on success, 0 on failure
 */
int32_t exportCrosshairAsSvg(int32_t shape_index, uint32_t color_value, double size, double thickness, double opacity, const char* output_path);

/**
 * Get the last error message from the engine.
 * 
 * @return A pointer to a null-terminated string containing the error message
 */
const char* getLastError();

/**
 * Cleans up resources used by the crosshair engine.
 * Should be called when the engine is no longer needed.
 */
void cleanup();

#ifdef __cplusplus
}  // extern "C"
#endif

#endif // CROSSHAIR_ENGINE_H
