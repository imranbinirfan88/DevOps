<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Secure Flipbook Viewer</title>
    <style>
        body {
            font-family: sans-serif;
            background-color: #eaeaea;
            padding: 20px;
            text-align: center;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        #flipbook {
            width: 800px;
            height: 500px;
            margin: 0 auto;
        }

        #flipbook .page {
            width: 400px;
            height: 500px;
            position: relative;
        }

        #flipbook .page img {
            width: 100%;
            height: 100%;
            pointer-events: none; /* disable drag */
            -webkit-user-drag: none;
            user-drag: none;
        }

        /* Screenshot blur (when PrintScreen key is detected) */
        .blur-protect * {
            filter: blur(10px) !important;
        }
    </style>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="<?= base_url('assets/turnjs/turn.min.js'); ?>"></script>
</head>
<body oncontextmenu="return false">

<h2>PDF Flipbook Viewer (Protected)</h2>

<div id="flipbook">
    <?php
    natsort($pages);
    foreach ($pages as $imgPath):
        $imgUrl = base_url(str_replace(FCPATH, '', $imgPath));
    ?>
        <div class="page"><img src="<?= $imgUrl ?>" alt="Protected Page"></div>
    <?php endforeach; ?>
</div>

<script>
    // Initialize flipbook
    $('#flipbook').turn({
        width: 800,
        height: 500,
        autoCenter: true
    });

    // Disable keyboard shortcuts (Ctrl+S, Ctrl+U, PrintScreen)
    $(document).keydown(function(e) {
        if (
            (e.ctrlKey && (e.key === 's' || e.key === 'S' || e.key === 'u' || e.key === 'U')) ||
            (e.key === 'PrintScreen')
        ) {
            e.preventDefault();
            blurScreenTemporarily();
        }
    });

    // Blur screen temporarily on screenshot attempt
    function blurScreenTemporarily() {
        $('body').addClass('blur-protect');
        setTimeout(() => {
            $('body').removeClass('blur-protect');
        }, 5000); // blur for 5 seconds
    }

    // Disable right-click
    $(document).on("contextmenu", function(e) {
        return false;
    });

    // Disable dragging of images
    $('img').on('dragstart', function(e) {
        e.preventDefault();
    });

    // Disable F12 and Ctrl+Shift+I (DevTools)
    document.addEventListener("keydown", function(e) {
        if (e.key === "F12" || (e.ctrlKey && e.shiftKey && e.key === "I")) {
            e.preventDefault();
        }
    });
</script>

</body>
</html>
