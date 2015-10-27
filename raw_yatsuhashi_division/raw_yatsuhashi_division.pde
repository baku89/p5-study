//==============================
// const

final float handleLength = 0.55;

final float gourdDist = 2;
final float twinDist = 3;

final float gourdTime = 0.5;

final float radius = 50;

//==============================

void setup() {

    size(640, 640);
    background(0);
}


void draw() {
    
    background(0);
    
    float t = float(mouseX) / width;
    
    //println(t);
    
    drawCell(width/2, height/2, radius, t);
}


void drawCell(float x, float y, float r, float t) {

    pushMatrix();
    //noStroke();
    stroke(255);
    noFill();
    //fill(255, 0, 0);
    
    translate(x, y);
    
    // handle length
    float h = r * handleLength;
    
    
    
    if (t == 0) {
        
        // 0: circle
        beginShape();
        vertex(0, -r);
        bezierVertex(h, -r, r, -h, r, 0);
        bezierVertex(r, h, h, r, 0, r);
        bezierVertex(-h, r, -r, h, -r, 0);
        bezierVertex(-r, -h, -h, -r, 0, -r);
        endShape();
    
    } else if (t < gourdTime) {
        
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
        
        println(d);
        
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