import controlP5.*;
import processing.svg.*;
import java.util.Collections;
import java.util.ArrayList;
import java.io.File;

ControlP5 cp5;
ColorWheel cpFill;
ColorWheel cpBg;

int numberOfShapes;
int numberOfFiles = 24;
int cellSize = 540;

int shapeFill = color(255, 255, 255, 255);
int bgColor = color(254, 250, 146, 255);

PShape[] svgs;
PGraphics preview;

void setup() {
  size(1920, 1080);
  preview = createGraphics(1920, 1080, JAVA2D);
  cp5 = new ControlP5(this);
  
  File dir = new File(sketchPath("assets"));
  File[] files = dir.listFiles((File file) -> file.getName().endsWith(".svg"));
  svgs = new PShape[files.length];
  numberOfShapes = files.length;
  
  for (int i = 0; i < files.length; i++) {
    svgs[i] = loadShape(files[i].getAbsolutePath());
    svgs[i].disableStyle();
    float w = svgs[i].width;
    float h = svgs[i].height;
  }
  
  cp5.addButton("Export")
   .setPosition(10, 10)
   .setSize(80, 40)
   .addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      exportSVGs();
    }
  }
 );
  
  updatePreview();
}

void draw() {
  background(bgColor);
  image(preview, 0, 0, width, height);
}

void updatePreview() {
  preview.beginDraw();
  preview.background(bgColor);
  preview.fill(shapeFill);
  preview.noStroke();
  
  float x = 0;
  float y = 0;
  int index = 0;
  
  while(y + cellSize <= height) {
    while(x + cellSize <= width) {
      if (index >= numberOfShapes) index = 0;
      
      float innerCellSize = cellSize / 3.0;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (random(1) < 0.5) {
            float w = svgs[index].width;
            float h = svgs[index].height;
            float scaleFactor = innerCellSize / max(w, h);
            
            preview.pushMatrix();
            preview.translate(x + i * innerCellSize + innerCellSize / 2, y + j * innerCellSize + innerCellSize / 2);
            preview.scale(scaleFactor);
            preview.shape(svgs[(int)random(numberOfShapes)], -w / 2, -h / 2);
            preview.popMatrix();
          }
        }
      }
      
      x += cellSize;
      index++;
    }
    x = 0;
    y += cellSize;
  }
  
  preview.endDraw();
}

void exportSVGs() {
  String username = System.getProperty("user.name");
  String baseFolderPath = "/Users/" + username + "/Downloads/HAI";
  String folderPath = baseFolderPath + "-01";
  File folderDir = new File(folderPath);
  int suffix = 2;
  
  while(folderDir.exists()) {
    folderPath = baseFolderPath + "-" + nf(suffix++, 2);
    folderDir = new File(folderPath);
  }
  folderDir.mkdirs();
  
  for (int fileNum = 1; fileNum <= numberOfFiles; fileNum++) {
    String filePath = folderPath + "/output-" + nf(fileNum, 2) + ".svg";
    PGraphics pg = createGraphics(1920, 1080, SVG, filePath);
    pg.beginDraw();
    pg.background(bgColor);
    pg.noStroke();
    pg.fill(shapeFill);
    
    float x = 0;
    float y = 0;
    int index = 0;
    
    while(y + cellSize <= pg.height) {
      while(x + cellSize <= pg.width) {
        if (index >= numberOfShapes) index = 0;
        
        float innerCellSize = cellSize / 3.0;
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            if (random(1) < 0.5) {
              float w = svgs[index].width;
              float h = svgs[index].height;
              float scaleFactor = innerCellSize / max(w, h);
              
              pg.pushMatrix();
              pg.translate(x + i * innerCellSize + innerCellSize / 2, y + j * innerCellSize + innerCellSize / 2);
              pg.scale(scaleFactor);
              pg.shape(svgs[(int)random(numberOfShapes)], -w / 2, -h / 2);
              pg.popMatrix();
            }
          }
        }
        
        x += cellSize;
        index++;
      }
      x = 0;
      y += cellSize;
    }
    
    pg.endDraw();
    pg.dispose();
  }
}
