
-- AI TOOLS  — DATABASE

CREATE DATABASE IF NOT EXISTS ai_tools
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE ai_tools;

-- USERS

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,

    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,

    email VARCHAR(200) NOT NULL UNIQUE,

    password_hash VARCHAR(255) NOT NULL,

    avatar_url VARCHAR(255) DEFAULT NULL,

    role ENUM('user', 'admin')
    DEFAULT 'user',

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP
);

-- CATEGORIES

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(100) NOT NULL UNIQUE,

    description TEXT,

    icon VARCHAR(20),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- COMPANIES
-- =========================================================

CREATE TABLE companies (
    id INT AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(150) NOT NULL UNIQUE,

    website VARCHAR(255),

    country VARCHAR(100),

    logo_url VARCHAR(255) DEFAULT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AI TOOLS

CREATE TABLE ai_tools (
    id INT AUTO_INCREMENT PRIMARY KEY,

    category_id INT DEFAULT NULL,

    company_id INT DEFAULT NULL,

    name VARCHAR(150) NOT NULL UNIQUE,

    slug VARCHAR(180) NOT NULL UNIQUE,

    description TEXT NOT NULL,

    website_url VARCHAR(255),

    icon VARCHAR(20),

    pricing_type ENUM(
        'free',
        'freemium',
        'paid',
        'enterprise'
    ) DEFAULT 'freemium',

    average_rating DECIMAL(2,1)
    DEFAULT 0.0,

    total_reviews INT DEFAULT 0,

    total_favorites INT DEFAULT 0,

    launch_date DATE,

    is_new BOOLEAN DEFAULT FALSE,

    api_available BOOLEAN DEFAULT FALSE,

    access_platforms VARCHAR(255),

    supported_languages VARCHAR(255),

    free_plan_details VARCHAR(255),

    pro_plan_details VARCHAR(255),

    integrations TEXT,

    status ENUM('active', 'inactive')
    DEFAULT 'active',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (category_id)
    REFERENCES categories(id)
    ON DELETE SET NULL,

    FOREIGN KEY (company_id)
    REFERENCES companies(id)
    ON DELETE SET NULL
);

-- =========================================================
-- TOOL IMAGES
-- =========================================================

CREATE TABLE tool_images (
    id INT AUTO_INCREMENT PRIMARY KEY,

    tool_id INT NOT NULL,

    image_url VARCHAR(255) NOT NULL,

    is_primary BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (tool_id)
    REFERENCES ai_tools(id)
    ON DELETE CASCADE
);

-- =========================================================
-- TAGS
-- =========================================================

CREATE TABLE tags (
    id INT AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(100) NOT NULL UNIQUE
);

-- =========================================================
-- TOOL TAGS
-- =========================================================

CREATE TABLE tool_tags (
    tool_id INT NOT NULL,
    tag_id INT NOT NULL,

    PRIMARY KEY (tool_id, tag_id),

    FOREIGN KEY (tool_id)
    REFERENCES ai_tools(id)
    ON DELETE CASCADE,

    FOREIGN KEY (tag_id)
    REFERENCES tags(id)
    ON DELETE CASCADE
);

-- =========================================================
-- REVIEWS
-- =========================================================

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    tool_id INT NOT NULL,

    rating INT NOT NULL
    CHECK (rating BETWEEN 1 AND 5),

    review_text TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE(user_id, tool_id),

    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE,

    FOREIGN KEY (tool_id)
    REFERENCES ai_tools(id)
    ON DELETE CASCADE
);

-- =========================================================
-- COMMENTS
-- =========================================================

CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    tool_id INT NOT NULL,

    content TEXT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE,

    FOREIGN KEY (tool_id)
    REFERENCES ai_tools(id)
    ON DELETE CASCADE
);

-- =========================================================
-- FAVORITES
-- =========================================================

CREATE TABLE favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    tool_id INT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(user_id, tool_id),

    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE,

    FOREIGN KEY (tool_id)
    REFERENCES ai_tools(id)
    ON DELETE CASCADE
);

-- =========================================================
-- SEARCH HISTORY
-- =========================================================

CREATE TABLE search_history (
    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    query_text VARCHAR(255),

    category_id INT DEFAULT NULL,

    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE,

    FOREIGN KEY (category_id)
    REFERENCES categories(id)
    ON DELETE SET NULL
);

-- =========================================================
-- REPORTS
-- =========================================================

CREATE TABLE reports (
    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    comment_id INT NOT NULL,

    reason VARCHAR(255),

    status ENUM(
        'pending',
        'reviewed',
        'rejected'
    ) DEFAULT 'pending',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE,

    FOREIGN KEY (comment_id)
    REFERENCES comments(id)
    ON DELETE CASCADE
);

-- =========================================================
-- INDEXES
-- =========================================================

CREATE INDEX idx_tool_name
ON ai_tools(name);

CREATE INDEX idx_tool_slug
ON ai_tools(slug);

CREATE INDEX idx_tool_category
ON ai_tools(category_id);

CREATE INDEX idx_tool_company
ON ai_tools(company_id);

CREATE INDEX idx_review_tool
ON reviews(tool_id);

CREATE INDEX idx_review_user
ON reviews(user_id);

CREATE INDEX idx_favorite_user
ON favorites(user_id);

CREATE INDEX idx_search_user
ON search_history(user_id);

-- =========================================================
-- CATEGORIES
-- =========================================================

INSERT INTO categories (name, description, icon) VALUES
('Texte & écriture', 'Assistants texte et LLMs', '📝'),
('Image & design', 'Génération d images', '🎨'),
('Vidéo', 'Création vidéo IA', '🎬'),
('Audio & musique', 'Synthèse vocale et musique', '🎵'),
('Code', 'Assistants de programmation', '💻'),
('Productivité', 'Outils de productivité', '⚡'),
('Recherche', 'Moteurs de recherche IA', '🔍'),
('Chatbots', 'Assistants conversationnels', '💬'),
('Données & analyse', 'Analyse de données', '📊'),
('Avatar & voix', 'Avatars IA', '🧑');

-- =========================================================
-- COMPANIES
-- =========================================================

INSERT INTO companies (name, country, website) VALUES
('OpenAI','USA','https://openai.com'),
('Anthropic','USA','https://anthropic.com'),
('Google DeepMind','USA','https://deepmind.google'),
('Mistral AI','France','https://mistral.ai'),
('Perplexity AI','USA','https://perplexity.ai'),
('Midjourney Inc.','USA','https://midjourney.com'),
('Stability AI','UK','https://stability.ai'),
('Canva','Australie','https://canva.com'),
('Runway ML','USA','https://runwayml.com'),
('Kuaishou','Chine','https://klingai.com'),
('ElevenLabs','USA','https://elevenlabs.io'),
('Suno AI','USA','https://suno.ai'),
('Udio','USA','https://udio.com'),
('GitHub / Microsoft','USA','https://github.com'),
('Anysphere','USA','https://cursor.sh'),
('Replit','USA','https://replit.com'),
('Notion Labs','USA','https://notion.so'),
('Gamma App','USA','https://gamma.app'),
('HeyGen','USA','https://heygen.com'),
('Synthesia','UK','https://synthesia.io'),
('Cohere','Canada','https://cohere.com'),
('Julius AI','USA','https://julius.ai'),
('xAI','USA','https://x.ai'),
('Meta','USA','https://ai.meta.com'),
('Microsoft','USA','https://microsoft.com'),
('You.com','USA','https://you.com'),
('Jasper AI','USA','https://jasper.ai'),
('Copy.ai','USA','https://copy.ai'),
('Adobe','USA','https://adobe.com'),
('Pika Labs','USA','https://pika.art'),
('Murf AI','USA','https://murf.ai'),
('Zapier','USA','https://zapier.com'),
('Genspark','USA','https://genspark.ai'),
('Luma AI','USA','https://lumalabs.ai'),
('Pinecone Systems','USA','https://pinecone.io'),
('Consensus NLP','USA','https://consensus.app'),
('Descript','USA','https://descript.com');

-- =========================================================
-- AI TOOLS
-- =========================================================

INSERT INTO ai_tools (
    category_id,
    company_id,
    name,
    slug,
    description,
    website_url,
    icon,
    pricing_type,
    average_rating,
    launch_date,
    is_new,
    api_available,
    access_platforms,
    supported_languages,
    free_plan_details,
    pro_plan_details,
    integrations,
    total_reviews,
    total_favorites
) VALUES

(
1,1,
'ChatGPT',
'chatgpt',
'Assistant conversationnel multimodal, le plus utilise au monde.',
'https://chat.openai.com',
'💬',
'freemium',
4.9,
'2022-11-01',
FALSE,
TRUE,
'Web, iOS, Android, API',
'100+ langues',
'40 msg / 3h',
'Illimite (GPT-4o)',
'Zapier, Slack, Make, Notion, Salesforce',
12000,
25000
),

(
1,2,
'Claude',
'claude',
'Assistant IA Anthropic, nuance et adapte aux longues analyses.',
'https://claude.ai',
'✦',
'freemium',
4.8,
'2023-03-01',
FALSE,
TRUE,
'Web, iOS, Android, API',
'50+ langues',
'~20 msg / jour',
'Illimite (Claude 4)',
'Zapier, Slack, Google Drive, Gmail',
6000,
11000
),

(
1,3,
'Gemini',
'gemini',
'IA multimodale de Google integree a Workspace.',
'https://gemini.google.com',
'✦',
'freemium',
4.5,
'2023-12-01',
FALSE,
TRUE,
'Web, iOS, Android, API',
'40+ langues',
'Illimite (Flash)',
'Illimite (Pro)',
'Google Workspace, Docs, Sheets, Gmail',
5000,
9000
),

(
7,5,
'Perplexity',
'perplexity',
'Moteur de recherche IA qui cite ses sources en temps reel.',
'https://perplexity.ai',
'🔍',
'freemium',
4.6,
'2023-01-01',
FALSE,
TRUE,
'Web, iOS, Android, API',
'30+ langues',
'5 Pro searches / jour',
'300 Pro searches / jour',
'API, Zapier',
4200,
7000
),

(
2,6,
'Midjourney',
'midjourney',
'Generation images artistiques haute qualite via prompts.',
'https://midjourney.com',
'🎨',
'paid',
4.9,
'2022-03-01',
FALSE,
FALSE,
'Web, Discord',
'EN',
'~25 images (trial)',
'Illimite (Fast GPU)',
'Discord',
8200,
15000
),

(
2,1,
'DALL-E 3',
'dall-e-3',
'Generateur images OpenAI integre a ChatGPT Plus.',
'https://openai.com/dall-e-3',
'🖼️',
'freemium',
4.6,
'2023-10-01',
FALSE,
TRUE,
'Web, API',
'Multilingue',
'15 images / mois (Bing)',
'Inclus ChatGPT Plus',
'ChatGPT, API OpenAI, Azure',
4100,
7600
),

(
3,9,
'Runway',
'runway',
'Creation et edition video avec IA generative (Gen-3).',
'https://runwayml.com',
'🎬',
'freemium',
4.7,
'2022-01-01',
TRUE,
TRUE,
'Web, API',
'EN',
'125 credits',
'2250 credits / mois',
'Adobe Premiere, API',
3900,
6800
),

(
3,1,
'Sora',
'sora',
'Generation videos realistes depuis texte par OpenAI.',
'https://sora.com',
'🎥',
'paid',
4.8,
'2024-02-01',
TRUE,
FALSE,
'Web',
'EN',
'Non disponible',
'50 videos / mois',
'ChatGPT Plus',
5200,
12000
),

(
4,11,
'ElevenLabs',
'elevenlabs',
'Synthese vocale ultra-realiste et clonage de voix.',
'https://elevenlabs.io',
'🎙️',
'freemium',
4.8,
'2023-01-01',
FALSE,
TRUE,
'Web, iOS, API',
'32 langues',
'10 000 caracteres / mois',
'100 000 caracteres / mois',
'Zapier, Make, API REST',
4600,
8200
),

(
5,14,
'GitHub Copilot',
'github-copilot',
'Assistant programmation IA integre a VS Code & GitHub.',
'https://github.com/features/copilot',
'💻',
'paid',
4.7,
'2021-10-01',
FALSE,
TRUE,
'Desktop, Web, API',
'Tous langages',
'2000 completions / mois',
'Illimite',
'VS Code, JetBrains, Neovim, GitHub',
8700,
17000
),

(
5,15,
'Cursor',
'cursor',
'Editeur de code avec IA integree pour generer et refactorer.',
'https://cursor.sh',
'⌨️',
'freemium',
4.8,
'2023-01-01',
TRUE,
FALSE,
'Desktop',
'Tous langages',
'2000 completions / mois',
'Illimite',
'GitHub, VS Code extensions',
7000,
14500
),

(
6,17,
'Notion AI',
'notion-ai',
'IA integree a Notion pour rediger, resumer, organiser.',
'https://notion.so/product/ai',
'📝',
'paid',
4.4,
'2023-02-01',
FALSE,
FALSE,
'Web, iOS, Android, Desktop',
'Multilingue',
'20 requetes (trial)',
'Illimite',
'Slack, GitHub, Google Drive, Zapier',
3100,
5800
),

(
10,19,
'HeyGen',
'heygen',
'Videos avec avatars IA realistes et traduction lip-sync.',
'https://heygen.com',
'🧑',
'freemium',
4.5,
'2022-01-01',
TRUE,
TRUE,
'Web, API',
'40+ langues',
'1 video / mois',
'15 videos / mois',
'Zapier, API REST, HubSpot',
2500,
4300
),

(
9,22,
'Julius AI',
'julius-ai',
'Analyse de donnees et visualisation automatique par IA.',
'https://julius.ai',
'📈',
'freemium',
4.4,
'2023-01-01',
TRUE,
FALSE,
'Web',
'EN/FR/ES/DE',
'15 requetes / mois',
'250 requetes / mois',
'Google Sheets, CSV, Excel',
1800,
2900
),

(
8,23,
'Grok',
'grok',
'Assistant IA xAI integre a X (Twitter), acces temps reel.',
'https://x.ai/grok',
'🤖',
'freemium',
4.4,
'2023-11-01',
TRUE,
TRUE,
'Web, iOS, Android, API',
'Multilingue',
'10 requetes / 2h',
'Illimite (X Premium+)',
'X (Twitter), API xAI',
3300,
5100
);

-- =========================================================
-- ADMIN USER
-- Password: Admin1234!
-- =========================================================

INSERT INTO users (
    first_name,
    last_name,
    email,
    password_hash,
    role,
    is_active
) VALUES (
    'Admin',
    'Hub',
    'admin@aitoolshub.com',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'admin',
    TRUE
);

-- =========================================================
-- ADMINS TABLE
-- =========================================================

CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL UNIQUE,

    admin_level ENUM(
        'super_admin',
        'manager',
        'moderator'
    ) DEFAULT 'moderator',

    permissions TEXT,

    last_login TIMESTAMP NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE
);

-- =========================================================
-- INSERT ADMIN
-- =========================================================

INSERT INTO admins (
    user_id,
    admin_level,
    permissions
) VALUES (
    1,
    'super_admin',
    'ALL_PERMISSIONS'
);

-- =========================================================
-- TAGS
-- =========================================================

INSERT INTO tags (name) VALUES
('LLM'),
('Chatbot'),
('Generative AI'),
('Image Generation'),
('Video Generation'),
('Voice Cloning'),
('Programming'),
('Productivity'),
('Search Engine'),
('Data Analysis'),
('Automation'),
('API'),
('Open Source'),
('AI Assistant'),
('Translation'),
('Text To Speech'),
('Speech To Text'),
('Machine Learning'),
('Writing'),
('Code Completion');

-- =========================================================
-- TOOL TAGS
-- =========================================================

INSERT INTO tool_tags (tool_id, tag_id) VALUES

-- ChatGPT
(1,1),(1,2),(1,3),(1,14),(1,19),

-- Claude
(2,1),(2,14),(2,19),

-- Gemini
(3,1),(3,14),(3,15),

-- Perplexity
(4,9),(4,14),

-- Midjourney
(5,4),(5,3),

-- DALL-E 3
(6,4),(6,3),

-- Runway
(7,5),(7,3),

-- Sora
(8,5),(8,3),

-- ElevenLabs
(9,6),(9,16),

-- GitHub Copilot
(10,7),(10,20),

-- Cursor
(11,7),(11,20),

-- Notion AI
(12,8),(12,19),

-- HeyGen
(13,5),(13,15),

-- Julius AI
(14,10),(14,18),

-- Grok
(15,1),(15,2),(15,14);

-- =========================================================
-- TOOL IMAGES
-- =========================================================

INSERT INTO tool_images (
    tool_id,
    image_url,
    is_primary
) VALUES

(1,'https://images.unsplash.com/photo-1677442136019-21780ecad995',TRUE),
(2,'https://images.unsplash.com/photo-1675557009875-436fcb5f5f3c',TRUE),
(3,'https://images.unsplash.com/photo-1686191128892-3f6b2d7d7c8d',TRUE),
(4,'https://images.unsplash.com/photo-1451187580459-43490279c0fa',TRUE),
(5,'https://images.unsplash.com/photo-1545239351-1141bd82e8a6',TRUE),
(6,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',TRUE),
(7,'https://images.unsplash.com/photo-1492619375914-88005aa9e8fb',TRUE),
(8,'https://images.unsplash.com/photo-1516321318423-f06f85e504b3',TRUE),
(9,'https://images.unsplash.com/photo-1516321497487-e288fb19713f',TRUE),
(10,'https://images.unsplash.com/photo-1515879218367-8466d910aaa4',TRUE),
(11,'https://images.unsplash.com/photo-1517694712202-14dd9538aa97',TRUE),
(12,'https://images.unsplash.com/photo-1484417894907-623942c8ee29',TRUE),
(13,'https://images.unsplash.com/photo-1521737604893-d14cc237f11d',TRUE),
(14,'https://images.unsplash.com/photo-1551288049-bebda4e38f71',TRUE),
(15,'https://images.unsplash.com/photo-1516321165247-4aa89a48be28',TRUE);

-- =========================================================
-- USERS
-- =========================================================

INSERT INTO users (
    first_name,
    last_name,
    email,
    password_hash,
    avatar_url,
    role,
    is_active
) VALUES

(
'John',
'Doe',
'john@example.com',
'$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
'https://i.pravatar.cc/150?img=1',
'user',
TRUE
),

(
'Sarah',
'Miller',
'sarah@example.com',
'$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
'https://i.pravatar.cc/150?img=2',
'user',
TRUE
),

(
'David',
'Wilson',
'david@example.com',
'$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
'https://i.pravatar.cc/150?img=3',
'user',
TRUE
),

(
'Emma',
'Brown',
'emma@example.com',
'$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
'https://i.pravatar.cc/150?img=4',
'user',
TRUE
),

(
'Yassine',
'Bennani',
'yassine@example.com',
'$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
'https://i.pravatar.cc/150?img=5',
'user',
TRUE
);

-- =========================================================
-- REVIEWS
-- =========================================================

INSERT INTO reviews (
    user_id,
    tool_id,
    rating,
    review_text
) VALUES

(2,1,5,'Excellent assistant IA pour tout type de travail.'),
(3,1,5,'Tres utile pour apprendre et coder.'),
(4,2,4,'Claude est excellent pour les longues analyses.'),
(5,5,5,'Midjourney cree des images incroyables.'),
(6,10,5,'Copilot accelere enormement le developpement.'),
(2,11,5,'Cursor est devenu mon IDE prefere.'),
(3,7,4,'Runway facilite le montage video IA.'),
(4,9,5,'Voix ultra realistes avec ElevenLabs.'),
(5,4,4,'Perplexity est parfait pour la recherche.'),
(6,12,4,'Notion AI aide beaucoup en productivite.');

-- =========================================================
-- COMMENTS
-- =========================================================

INSERT INTO comments (
    user_id,
    tool_id,
    content
) VALUES

(2,1,'Je recommande fortement ChatGPT pour les etudiants.'),
(3,5,'Midjourney produit des rendus magnifiques.'),
(4,10,'GitHub Copilot me fait gagner beaucoup de temps.'),
(5,9,'Le clonage vocal est impressionnant.'),
(6,4,'Perplexity est meilleur que Google pour certaines recherches.'),
(2,7,'Runway Gen-3 est tres puissant pour la video.'),
(3,11,'Cursor facilite la refactorisation de code.'),
(4,2,'Claude comprend tres bien les longs documents.');

-- =========================================================
-- FAVORITES
-- =========================================================

INSERT INTO favorites (
    user_id,
    tool_id
) VALUES

(2,1),
(2,10),
(3,5),
(3,11),
(4,2),
(4,7),
(5,9),
(5,1),
(6,4),
(6,12);

-- =========================================================
-- SEARCH HISTORY
-- =========================================================

INSERT INTO search_history (
    user_id,
    query_text,
    category_id
) VALUES

(2,'best ai chatbot',8),
(2,'image generation tools',2),
(3,'code assistant ai',5),
(3,'video ai tools',3),
(4,'text generation ai',1),
(4,'ai for productivity',6),
(5,'voice cloning ai',4),
(5,'best llm 2026',1),
(6,'data analysis ai',9),
(6,'ai search engine',7);

-- =========================================================
-- REPORTS
-- =========================================================

INSERT INTO reports (
    user_id,
    comment_id,
    reason,
    status
) VALUES

(2,3,'Spam content','reviewed'),
(3,5,'Incorrect information','pending'),
(4,2,'Off-topic comment','rejected');

-- =========================================================
-- UPDATE TOOL STATS
-- =========================================================

UPDATE ai_tools SET
average_rating = 5.0,
total_reviews = 2,
total_favorites = 2
WHERE id = 1;

UPDATE ai_tools SET
average_rating = 4.0,
total_reviews = 1,
total_favorites = 1
WHERE id = 2;

UPDATE ai_tools SET
average_rating = 5.0,
total_reviews = 1,
total_favorites = 1
WHERE id = 5;

UPDATE ai_tools SET
average_rating = 4.0,
total_reviews = 1,
total_favorites = 1
WHERE id = 7;

UPDATE ai_tools SET
average_rating = 5.0,
total_reviews = 1,
total_favorites = 1
WHERE id = 9;

UPDATE ai_tools SET
average_rating = 5.0,
total_reviews = 1,
total_favorites = 1
WHERE id = 10;

UPDATE ai_tools SET
average_rating = 5.0,
total_reviews = 1,
total_favorites = 1
WHERE id = 11;

UPDATE ai_tools SET
average_rating = 4.0,
total_reviews = 1,
total_favorites = 1
WHERE id = 12;
