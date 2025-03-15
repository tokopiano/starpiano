#!/bin/bash

# Variables
PROJECT_NAME="piano-business"
GITHUB_USERNAME="tokopiano"  # Replace with your GitHub username
REPO_NAME="starpiano"
SITE_TITLE="PianoFlow"
SITE_DESCRIPTION="Unlock Your Musical Potential – One Key at a Time."
DEV_CONTAINER_DIR=".devcontainer"
ASSETS_DIR="assets"
CSS_DIR="$ASSETS_DIR/css"
IMAGES_DIR="$ASSETS_DIR/images"
POSTS_DIR="_posts"

# Step 1: Install Jekyll and Create a New Site
echo "Step 1: Installing Jekyll and creating a new site..."
gem install jekyll bundler
jekyll new $PROJECT_NAME
cd $PROJECT_NAME

# Step 2: Initialize Git Repository
echo "Step 2: Initializing Git repository..."
git init
git add .
git commit -m "Initial commit"

# Step 3: Set Up GitHub Pages
echo "Step 3: Setting up GitHub Pages..."
git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
git branch -M main
git push -u origin main

# Step 4: Create Dev Container Configuration
echo "Step 4: Setting up Dev Container..."
mkdir -p $DEV_CONTAINER_DIR
cat <<EOL > $DEV_CONTAINER_DIR/devcontainer.json
{
  "name": "Jekyll Dev Container",
  "dockerFile": "Dockerfile",
  "context": "..",
  "settings": {
    "terminal.integrated.shell.linux": "/bin/bash"
  },
  "extensions": ["dbaeumer.vscode-eslint"]
}
EOL

cat <<EOL > $DEV_CONTAINER_DIR/Dockerfile
FROM ruby:3.0
RUN apt-get update && apt-get install -y nodejs
RUN gem install jekyll bundler
WORKDIR /workspace
COPY . .
RUN bundle install
EOL

# Step 5: Update Jekyll Configuration
echo "Step 5: Updating Jekyll configuration..."
cat <<EOL >> _config.yml
title: $SITE_TITLE
description: $SITE_DESCRIPTION
theme: minima
plugins:
  - jekyll-feed
  - jekyll-seo-tag
EOL

# Step 6: Create Custom CSS
echo "Step 6: Creating custom CSS..."
mkdir -p $CSS_DIR
cat <<EOL > $CSS_DIR/style.scss
---
---
@import "minima";

body {
  font-family: 'Lato', sans-serif;
}

h1, h2, h3 {
  font-family: 'Playfair Display', serif;
}

.hero {
  background-image: url('/assets/images/piano-background.jpg');
  background-size: cover;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  text-align: center;
}

.btn {
  background-color: gold;
  color: black;
  padding: 10px 20px;
  text-decoration: none;
  border-radius: 5px;
}
EOL

# Step 7: Add Homepage Content
echo "Step 7: Adding homepage content..."
cat <<EOL > index.md
---
layout: home
---
<div class="hero">
  <h1>Unlock Your Musical Potential</h1>
  <p>One Key at a Time.</p>
  <a href="/lessons" class="btn">Book a Lesson Today</a>
</div>
EOL

# Step 8: Add Example Blog Post
echo "Step 8: Adding example blog post..."
mkdir -p $POSTS_DIR
cat <<EOL > $POSTS_DIR/2023-10-01-welcome.md
---
layout: post
title: "Welcome to My Piano Journey"
date: 2023-10-01
---
Hi there! I'm [Your Name], a passionate piano teacher with over 10 years of experience. My goal is to make learning piano fun and accessible for everyone. Whether you're a beginner or an advanced player, I’m here to guide you every step of the way. Let’s create beautiful music together!
EOL

# Step 9: Add Icons and Images
echo "Step 9: Adding icons and images..."
mkdir -p $IMAGES_DIR
wget -O $IMAGES_DIR/piano-background.jpg https://source.unsplash.com/1600x900/?piano,music

# Step 10: Push Changes to GitHub
echo "Step 10: Pushing changes to GitHub..."
git add .
git commit -m "Added piano business website setup"
git push origin main

# Step 11: Enable GitHub Pages
echo "Step 11: Enabling GitHub Pages..."
gh repo edit --enable-pages --pages-branch=main

echo "Setup complete! Your website is now live at: https://$GITHUB_USERNAME.github.io/$REPO_NAME"