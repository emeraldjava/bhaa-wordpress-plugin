<?php
namespace BHAA\utils;

use RecursiveIteratorIterator;
use RecursiveDirectoryIterator;
use RecursiveCallbackFilterIterator;
use ZipArchive;

// https://stackoverflow.com/questions/4914750/how-to-zip-a-whole-folder-using-php
class ReleaseBuilder {

    public static function createZip() {
        $todaysDate = date('Ymd');
        $zipFileName = 'bhaa_wordpress_plugin-'.$todaysDate.'.zip';
        printf("ReleaseBuilder: ".$zipFileName.' '.PHP_EOL);
        //printf("basename ".basename(__DIR__).PHP_EOL);
        $zip = new ZipArchive;
        $zip->open($zipFileName, ZipArchive::CREATE);
        $rootPath = realpath(__DIR__ . '/../..');
        //printf("rootPath ".$rootPath.PHP_EOL);

        $exclude = array('.git','.github','.idea','tests','docs');
        $filter = function ($file, $key, $iterator) use ($exclude) {
            if ($iterator->hasChildren() && !in_array($file->getFilename(), $exclude)) {
                return true;
            }
            return $file->isFile();
        };

        $innerIterator = new RecursiveDirectoryIterator(
            $rootPath,
            RecursiveDirectoryIterator::SKIP_DOTS
        );
        $files = new RecursiveIteratorIterator(
            new RecursiveCallbackFilterIterator($innerIterator, $filter)
        );

        foreach ($files as $name => $file)
        {
            // Skip directories (they would be added automatically)
            if (!$file->isDir())
            {
                // Get real and relative path for current file
                $filePath = $file->getRealPath();
                $relativePath = substr($filePath, strlen($rootPath) + 1);

                // Add current file to archive
                $zip->addFile($filePath, $relativePath);
            }
        }

        // Zip archive will be created only after closing object
        $zip->close();
    }
}
?>