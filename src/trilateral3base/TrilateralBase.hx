package trilateral3base;
// hyperKitGL specific
import hyperKitGL.PlyMix;
import hyperKitGL.DataGL;
// trilateral setup pens
import trilateral3.drawing.Pen;
import trilateral3.nodule.PenColor;
import trilateral3.nodule.PenTexture;
import trilateral3.nodule.PenArrColor;
import trilateral3.nodule.PenArrTexture;
// setup sketching
import trilateral3.drawing.StyleEndLine;
import trilateral3.drawing.Sketch;
import trilateral3.drawing.StyleSketch;
import trilateral3.drawing.Fill;
// used for storing data to be drawn every frame.
import trilateral3.structure.RangeEntity;
// To trace on screen
import hyperKitGL.DivertTrace;

abstract class TrilateralBase extends PlyMix {
    public var penColor:            Pen;
    public var penNoduleColor       = new PenArrColor();
    public var penTexture:          Pen;
    public var penNoduleTexture     = new PenArrTexture();
    public var sketchColor:         Sketch;
    public var sketchTexture:       Sketch;
    public var imgW:                Int;
    public var imgH:                Int;
    public var imageRatio:          Float;
    public var draw_Shape           = new Array<RangeEntity>();
    
    public function new( width: Int, height: Int, testImage: String = '' ){
        super( width, height );
        if( testImage != '' ) {
            loadTestImage( testImage ); 
        } else {
            trace( 'new - no testImage supplied, will need to start' );
        }
        var divertTrace = new DivertTrace();
    }
    // provide and drawing prior to render loop
    abstract function firstDraw(): Void {
       
    } 
    // this is the initalization of the drawing and run once.
    override
    public function draw(){
        trace( 'draw ' );
        setupImage();
        setupDrawingPens();
        setupSketch();
        firstDraw();
    }
    // loads in an initial encoded image prior to start, normally supplied when new, but can be done manually.
    public inline 
    function loadTestImage( encodedString: String ){
        // built in load images
        imageLoader.loadEncoded( [ encodedString ],[ 'TestImage' ] );
    }
    inline 
    function setupImage(){
        trace('setupImage');
        img             = imageLoader.imageArr[ 0 ];
        imgW            = img.width;
        imgH            = img.height;
        imageRatio      = img.height/img.width;
        // image tranform.
        transformUVArr = [ 2.,0.,0.
                         , 0.,2./imageRatio,0.
                         , 0.,0.,1.];
    }
    inline
    function setupDrawingPens(){
        trace('setupDrawingPens');
        setupNoduleBuffers();
        penInits();
    }
    // connects data buffers to pen drawing.
    inline
    function setupNoduleBuffers(){
        dataGLcolor   = { get_data: penNoduleColor.get_data
                        , get_size: penNoduleColor.get_size };
        dataGLtexture = { get_data: penNoduleTexture.get_data
                        , get_size: penNoduleTexture.get_size };
    }
    // provides two sketch tools one for color and one for texture.
    // for coarser drawing don't use Fine.
    inline 
    function setupSketch(){
        sketchTexture        = new Sketch( penTexture, StyleSketch.Fine, StyleEndLine.no );
        sketchColor          = new Sketch( penColor,   StyleSketch.Fine, StyleEndLine.no );
        sketchTexture.width  = 5;
        sketchColor.width    = 5;
    }
    inline
    function penInits(){
        penColor                = penNoduleColor.pen;
        penColor.currentColor   = 0xFFFFFFFF;
        penTexture              = penNoduleTexture.pen;
        penTexture.useTexture   = true;
        penTexture.currentColor = 0xffFFFFFF;
    }
    // animate every render frame.
    abstract function renderAnimate(): Void {
        
    }
    override
    public function renderDraw(){
        var haveTextures: Bool = false;
        var haveColors:   Bool = false;
        renderAnimate();
        for( a_shape in draw_Shape ){
            switch( a_shape.textured ){
                case true:
                    haveTextures = true;
                    drawTextureShape( a_shape.range.start, a_shape.range.max, a_shape.bgColor );
                case false:
                    haveColors = true;
                    drawColorShape( a_shape.range.start, a_shape.range.max );
            }
        }
        if( !haveColors ) tempHackFix();
    }
    inline
    function tempHackFix(){
        // need to work out why the color mode needs to be set each frame
        drawColorShape( 0, 0 );
    }
    public inline
    function debugTestImage(){
        showImageOnCanvas( img, imgW, imgH );   
    }
    public inline
    function showImageOnCanvas( img: Image, wid: Int, hi: Int ){
        mainSheet.cx.drawImage( img, 0, 0, wid, hi );
    }
}
