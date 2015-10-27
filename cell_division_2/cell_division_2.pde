//==============================
// const

final float handleLength = 0.55;

final float gourdDist = 2;
final float twinDist = 3;

final float gourdTime = 0.5;

final float radius = 50;

final float gamma = 1;
float animDur = 40;

//==============================

float time = 0;
float inFrame = 0;

float angle = 0;

boolean animating = false;
boolean prevState = false;
boolean curtState = false;

float prevX, prevY;

void setup() {

    size(640, 640);
    frameRate(60);
    background(0);
    
    prevX = mouseX;
    prevY = mouseY;
}

void draw() {
    
    background(0xf8f4e6);
    
    //println(t);
    
    curtState = dist(mouseX, mouseY, width/2, height/2) < radius;
    
    if (!animating && curtState && !prevState) {
    
        // start
        inFrame = frameCount;
        animating = true;
        
        angle = atan2(prevY - mouseY, prevX - mouseX);
        //animDur = dist(prevX, prevY, mouseX, mouseY) * 2;
        
        println( angle);
    }
    
    if (animating) {
        
        float off = frameCount - inFrame;
        float t = off / animDur;
        
        if (t >= 1.0) {
            animating = false;
        }
        
        // gamma
        float x = (t*2) - 1;
        
        float tg = 1 - x * x;
        
        
        drawCell(width/2, height/2, radius, tg);
    
    } else {
        drawCell(width/2, height/2, radius, 0);
    }
    
    prevState = curtState;
    prevX = mouseX;
    prevY = mouseY;
}


void drawCell(float x, float y, float r, float t) {

    pushMatrix();
    noStroke();
    //noFill();
    //fill(0xec6d71);
    
    translate(x, y);
    rotate(angle + PI/2);
    
    // handle length
    float h = r * handleLength;
    
    
    
    if (t == 0) {
        
        fill( 120, 200, 200);
        
        // 0: circle
        beginShape();
        vertex(0, -r);
        bezierVertex(h, -r, r, -h, r, 0);
        bezierVertex(r, h, h, r, 0, r);
        bezierVertex(-h, r, -r, h, -r, 0);
        bezierVertex(-r, -h, -h, -r, 0, -r);
        endShape();
    
    } else if (t < gourdTime) {
        
        
        fill(236, 109, 113);
        
        // 1: gourd
        float lt = t / gourdTime;
        float d = r * gourdDist * lt; // distance
        float b = r * (1 - lt);      // bridge width
        float gh = d * handleLength; // guard handle
    
    
        beginShape();
        vertex(0, -b);
        bezierVertex(gh, -b, d-gh, -r, d, -r);
        bezierVertex(d+h, -r, d+r, -h, d+r, 0);
        bezierVertex(d+r, h, d+h, r, d, r);
        bezierVertex(d-gh, r, gh, b, 0, b);
        bezierVertex(-gh, b, -d+gh, r, -d, r);
        bezierVertex(-d-h, r, -d-r, h, -d-r, 0);
        bezierVertex(-d-r, -h, -d-h, -r, -d, -r);
        bezierVertex(-d+gh, -r, -gh, -b, 0, -b);
        endShape();
    
    } else {
        
        // 2: twin
        float lt = (t-gourdTime) / (1-gourdTime);
        
        float gd = r * gourdDist; // gourd dist
        float td = r * twinDist;  // twin dist
        
        float gh = gd * handleLength; // gouard handle len
        
        float d = lerp(gd, td, lt);
        
        PVector tipVertex = new PVector(0, 0);
        PVector tipHandle = new PVector(r * gourdDist * handleLength, 0);
        
        float thl = r * gourdDist * handleLength;
        
        
        
        float tx  = lerp(0, td-r, lt);
        float thx = lerp(thl, td-r, lt);
        float thy = lerp(0, -h, lt);
        float rhx = d - lerp(gh, h, lt);
        
        
        // right half
        beginShape();
        vertex(tx, 0);
        bezierVertex(
            thx, thy,
            rhx, -r,
            d, -r
        );
        bezierVertex(d+h, -r, d+r, -h, d+r, 0);
        bezierVertex(d+r, h, d+h, r, d, r);
        bezierVertex(
            rhx, r,
            thx, -thy,
            tx, 0
        );
        endShape();
        
        beginShape();
        vertex(-tx, 0);
        bezierVertex(
           -thx, -thy,
           -rhx, r,
           -d, r
        );
        bezierVertex(-d-h, r, -d-r, h, -d-r, 0);
        bezierVertex(-d-r, -h, -d-h, -r, -d, -r);
        bezierVertex(
           -rhx, -r,
           -thx, thy,
           -tx, 0
        );
        endShape();
    }
        
    
    popMatrix();
}

//float lerp(float a, float b, float t) {
//    return a + (b-a) * t;
//}