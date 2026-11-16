<section class="page-hero">
    <span class="eyebrow">BIYODEX / SPECIES DIRECTORY</span>
    <h1>Welcome to the <em>HerbDex.</em></h1>
    <p>Explore our starter collection of Philippine medicinal plants. Learn their names, identifying information, and traditional context through source-linked profiles.</p>
</section>

<section class="intro">
    <span class="eyebrow">THE STARTER COLLECTION</span>
    <h2>Medicinal plants</h2>
    <p><?= (int) ($plantCount ?? 0) ?> plant profiles in the collection.</p>

    <?php if (empty($plants)): ?>
        <div class="notice">
            <h3>Your field guide is taking root.</h3>
            <p>No published plant records were found. Import the starter data SQL file and refresh this page.</p>
        </div>
    <?php else: ?>
        <div class="plant-grid">
            <?php foreach ($plants as $plant): ?>
                <article class="plant-card">
                    <div class="plant-card__image-placeholder" aria-hidden="true">🌿</div>
                    <div class="plant-card__content">
                        <span class="eyebrow"><?= htmlspecialchars((string) ($plant['category_name'] ?? 'Plant'), ENT_QUOTES, 'UTF-8') ?></span>
                        <h3><?= htmlspecialchars((string) $plant['common_name'], ENT_QUOTES, 'UTF-8') ?></h3>
                        <p class="plant-card__scientific"><em><?= htmlspecialchars((string) $plant['scientific_name'], ENT_QUOTES, 'UTF-8') ?></em></p>
                        <p><?= htmlspecialchars((string) ($plant['description'] ?? 'Profile details are being reviewed.'), ENT_QUOTES, 'UTF-8') ?></p>
                    </div>
                </article>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>

    <p class="research-note">Educational directory only. Traditional uses are presented for research and cultural context, not as personal medical advice. Consult qualified health professionals for health concerns.</p>
</section>
