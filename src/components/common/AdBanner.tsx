export function AdBanner() {
  return (
    <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8">
      <div className="relative w-full aspect-[4/1] bg-gradient-to-r from-gray-100 to-gray-200 rounded-2xl border border-dashed border-gray-300 flex items-center justify-center overflow-hidden hover:border-gray-400 transition-colors">
        <div className="text-center">
          <p className="text-[10px] text-gray-400 uppercase tracking-[0.2em] mb-1">Pubblicità</p>
          <p className="text-sm text-gray-500 font-medium">Spazio pubblicitario 1200 × 300 px</p>
        </div>
      </div>
    </div>
  );
}
