module salix::canvas::Canvas

import salix::HTML;
import salix::Node;
import salix::Core;
import List;

data PredefinedColorSpace = srgb() | \display-p3(); 
data CanvasFillRule  = nonzero() | evenodd(); 

data CanvasRenderingContext2DSettings = ctxSettings(
  bool alpha = true,
  bool desynchronized = false,
  PredefinedColorSpace colorSpace = srgb(),
  bool willReadFrequently = false
);


alias Path2D = list[Move];

data Move = M(int x, int y) ; // todo: finish


data ImageSmoothingQuality = low() | medium() | high();

data CanvasLineCap = butt() | round() | square();
data CanvasLineJoin = round() | bevel() | miter();
data CanvasTextAlign = \start() | end() | left() | right() | center();
data CanvasTextBaseline = top() | hanging() | middle() | alphabetic() | ideographic() | bottom();
data CanvasDirection = ltr() | rtl() | inherit();
data CanvasFontKerning = auto() | normal() | none();
data CanvasFontStretch = \ultra-condensed() | \extra-condensed() | condensed() | \semi-condensed() | normal() | \semi-expanded() | expanded() | \extra-expanded() | \ultra-expanded();
data CanvasFontVariantCaps = normal() | \small-caps() | \all-small-caps() | \petite-caps() | \all-petite-caps() | unicase() | \titling-caps();
data CanvasTextRendering = auto() | optimizeSpeed() | optimizeLegibility() | geometricPrecision();



alias GC = tuple[
    void(num /* x */, num /* y */) scale,
    void(num /* angle */) rotate,
    void(num /* x */, num /* y */) translate,
    void(num /* a */, num /* b */, num /* c */, num /* d */, num /* e */, num /* f */) transform,
    void(num /* x */, num /* y */, num /* w */, num /* h */) clearRect,
    void(num /* x */, num /* y */, num /* w */, num /* h */) fillRect,
    void(num /* x */, num /* y */, num /* w */, num /* h */) strokeRect,

    void() beginPath,
    void(CanvasFillRule /* fillRule */) fill,
    void(Path2D /* path */, CanvasFillRule /* fillRule */) fill,
    void() stroke,
    void(Path2D /* path */) stroke,
    void(CanvasFillRule /* fillRule */) clip,
    void(Path2D path, CanvasFillRule /* fillRule */) clip,

    void(str /* text */, num /* x */, num /* y */, num /* maxWidth */) fillText,
    void(str /* text */, num /* x */, num /* y */, num /* maxWidth */) strokeText,

    void(str /* image */, num /* dx */, num /* dy */) drawImage1,
    void(str /* image */, num /* dx */, num /* dy */, num /* dw */, num /* dh */) drawImage2,
    void(str /* image */, num /* sx */, num /* sy */, num /* sw */, num /* sh */, num /* dx */, num /* dy */, num /* dw */, num /* dh */) drawImage3,

    void() closePath,
    void(num /* x */, num /* y */) moveTo,
    void(num /* x */, num /* y */) lineTo,
    void(num /* cpx */, num /* cpy */, num /* x */, num /* y */) quadraticCurveTo,
    void(num /* cp1x */, num /* cp1y */, num /* cp2x */, num /* cp2y */, num /* x */, num /* y */) bezierCurveTo,
    void(num /* x1 */, num /* y1 */, num /* x2 */, num /* y2 */, num /* radius */) arcTo, 
    void(num /* x */, num /* y */, num /* w */, num /* h */) rect,
    void(num /* x */, num /* y */, num /* w */, num /* h */, list[num] /* radii */) roundRect,
    void(num /* x */, num /* y */, num /* radius */, num /* startAngle */, num /* endAngle */, bool counterclockwise) arc, 
    void(num /* x */, num /* y */, num /* radiusX */, num /* radiusY */, num /* rotation */, num /* startAngle */, num /* endAngle */, bool /* counterclockwise */) ellipse, 


    // Attributes
    void(num) globalAlpha, // (default 1.0)
    void(str) globalCompositeOperation, // (default "source-over")
    void(bool) imageSmoothingEnabled, // (default true)
    void(ImageSmoothingQuality) imageSmoothingQuality, // (default low)
    void(str) strokeStyle, // (default black)
    void(str) fillStyle, // (default black)
    void(num) shadowOffsetX, // (default 0)
    void(num) shadowOffsetY, // (default 0)
    void(num) shadowBlur, // (default 0)
    void(str) shadowColor, // (default transparent black)
    void(str) \filter, // (default "none")
    void(num) lineWidth, // (default 1)
    void(CanvasLineCap) lineCap, // (default "butt")
    void(CanvasLineJoin) lineJoin, // (default "miter")
    void(num) miterLimit, // (default 10)
    void (list[num] segments) setLineDash, // default empty
    void(num) lineDashOffset,
    void(str) font, // (default 10px sans-serif)
    void(CanvasTextAlign) textAlign, // (default: "start")
    void(CanvasTextBaseline) textBaseline, // (default: "alphabetic")
    void(CanvasDirection) direction, // (default: "inherit")
    void(str) letterSpacing, // (default: "0px")
    void(CanvasFontKerning) fontKerning, // (default: "auto")
    void(CanvasFontStretch) fontStretch, // (default: "normal")
    void(CanvasFontVariantCaps) fontVariantCaps, // (default: "normal")
    void(CanvasTextRendering) textRendering, // (default: "auto")
    void(str) wordSpacing // (default: "0px")

];





void myCanvas(str name, int w, int h, void(GC) block) {
    str ctx = "$ctx_<name>";
    list[str] lines = ["<ctx> = document.getElementById(\'<name>_canvas\').getContext(\'2d\');"];

    void line(str l) {
        lines += [l];
    }

    GC gc = <
    (num x, num y) /* scale */ { line("<ctx>."); },
    (num angle) /* rotate */ { line("<ctx>."); },
    (num x, num y) /* translate */ { line("<ctx>."); },
    (num a, num b, num c, num d, num e, num f) /* transform */ { line("<ctx>."); },
    (num x, num y, num w, num h) /* clearRect */ { line("<ctx>."); },
    (num x, num y, num w, num h) /* fillRect */ { line("<ctx>."); },
    (num x, num y, num w, num h) /* strokeRect */ { line("<ctx>."); },

    () /* beginPath */ { line("<ctx>."); },
    (CanvasFillRule fillRule) /* fill */ { line("<ctx>."); },
    (Path2D path, CanvasFillRule fillRule) /* fill */ { line("<ctx>."); },
    () /* stroke */ { line("<ctx>."); },
    (Path2D path) /* stroke */ { line("<ctx>."); },
    (CanvasFillRule fillRule) /* clip */ { line("<ctx>."); },
    (Path2D path, CanvasFillRule fillRule) /* clip */ { line("<ctx>."); },

    (str text, num x, num y, num maxWidth) /* fillText */ { line("<ctx>."); },
    (str text, num x, num y, num maxWidth) /* strokeText */ { line("<ctx>."); },

    (str image, num dx, num dy) /* drawImage */ { line("<ctx>."); },
    (str image, num dx, num dy, num dw, num dh) /* drawImage */ { line("<ctx>."); },
    (str image, num sx, num sy, num sw, num sh, num dx, num dy, num dw, num dh) /* drawImage */ { line("<ctx>."); },

    () /* closePath */ { line("<ctx>."); },
    (num x, num y) /* moveTo */ { line("<ctx>."); },
    (num x, num y) /* lineTo */ { line("<ctx>."); },
    (num cpx, num cpy, num x, num y) /* quadraticCurveTo */ { line("<ctx>."); },
    (num cp1x, num cp1y, num cp2x, num cp2y, num x, num y) /* bezierCurveTo */ { line("<ctx>."); },
    (num x1, num y1, num x2, num y2, num radius) /* arcTo */ { line("<ctx>."); }, 
    (num x, num y, num w, num h) /* rect */ { line("<ctx>."); },
    (num x, num y, num w, num h, list[num] radii) /* roundRect */ { line("<ctx>."); },
    (num x, num y, num radius, num startAngle, num endAngle, bool counterclockwise) /* arc */ { line("<ctx>."); }, 
    (num x, num y, num radiusX, num radiusY, num rotation, num startAngle, num endAngle, bool counterclockwise) /* ellipse */ { line("<ctx>."); }, 


    // Attributes
    (num val) /* globalAlpha */ { line("<ctx>."); }, // (default 1.0)
    (str val) /* globalCompositeOperation */ { line("<ctx>."); }, // (default "source-over")
    (bool val) /* imageSmoothingEnabled */ { line("<ctx>."); }, // (default true)
    (ImageSmoothingQuality val) /* imageSmoothingQuality */ { line("<ctx>."); }, // (default low)
    (str val) /* strokeStyle */ { line("<ctx>."); }, // (default black)
    (str val) /* fillStyle */ { line("<ctx>."); }, // (default black)
    (num val) /* shadowOffsetX */ { line("<ctx>."); }, // (default 0)
    (num val) /* shadowOffsetY */ { line("<ctx>."); }, // (default 0)
    (num val) /* shadowBlur */ { line("<ctx>."); }, // (default 0)
    (str val) /* shadowColor */ { line("<ctx>."); }, // (default transparent black)
    (str val) /* filter */ { line("<ctx>."); }, // (default "none")
    (num val) /* lineWidth */ { line("<ctx>."); }, // (default 1)
    (CanvasLineCap val) /* lineCap */ { line("<ctx>."); }, // (default "butt")
    (CanvasLineJoin val) /* lineJoin */ { line("<ctx>."); }, // (default "miter")
    (num val) /* miterLimit */ { line("<ctx>."); }, // (default 10)
    (list[num] segments) /* setLineDash */ { line("<ctx>."); }, // default empty
    (num val) /* lineDashOffset */ { line("<ctx>."); },
    (str val) /* font */ { line("<ctx>."); }, // (default 10px sans-serif)
    (CanvasTextAlign val) /* textAlign */ { line("<ctx>."); }, // (default: "start")
    (CanvasTextBaseline val) /* textBaseline */ { line("<ctx>."); }, // (default: "alphabetic")
    (CanvasDirection val) /* direction */ { line("<ctx>."); }, // (default: "inherit")
    (str val) /* letterSpacing */ { line("<ctx>."); }, // (default: "0px")
    (CanvasFontKerning val) /* fontKerning */ { line("<ctx>."); }, // (default: "auto")
    (CanvasFontStretch val) /* fontStretch */ { line("<ctx>."); }, // (default: "normal")
    (CanvasFontVariantCaps val) /* fontVariantCaps */ { line("<ctx>."); }, // (default: "normal")
    (CanvasTextRendering val) /* textRendering */ { line("<ctx>."); }, // (default: "auto")
    (str val) /* wordSpacing */ { line("<ctx>."); } // (default: "0px")
    >;

    block(gc);

    str theCode = intercalate("\n", lines);

    withExtra(("code": theCode), () {
        div(class("salix-alien"), id(name), attr("onclick", "$salix.registerAlien(\'<name>\', $canvas_patch_<name>);"), () {
            script("function $canvas_patch_<name>(patch) {
                   '    let scriptNode = document.createElement(\'script\');
                   '    scriptNode.type = \'text/javascript\';
                   '    let src = patch.edits[0].extra;
                   '    let srcNode = document.createTextNode(src);
                   '    scriptNode.appendChild(srcNode);
                   '    let alien = document.getElementById(\'<name>\');
                   '    alien.removeChild(alien.lastChild);
                   '    alien.appendChild(scriptNode);
                   '}");
            canvas(width(w), height(h), id("<name>_canvas"), "a canvas element");
            script(theCode);
        });

    });
}