import 'package:flutter/material.dart';

class StorageMeterCard extends StatelessWidget {
  final double totalStorageGb;
  final double usedStorageGb;
  final double reclaimableGb;
  final int reclaimableItemCount;
  final VoidCallback onFreeUpPressed;

  const StorageMeterCard({
    super.key,
    this.totalStorageGb = 128.0,
    this.usedStorageGb = 96.8,
    this.reclaimableGb = 14.8,
    this.reclaimableItemCount = 12,
    required this.onFreeUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double reclaimPercent = (reclaimableGb / totalStorageGb).clamp(0.0, 1.0);
    final double otherMediaPercent = 0.22;
    final double systemPercent = 0.45;
    final double freePercent = (1.0 - (systemPercent + otherMediaPercent + reclaimPercent)).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1B4B), // Deep indigo
            Color(0xFF0F172A), // Slate 900
            Color(0xFF064E3B), // Deep emerald
          ],
        ),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF312E81).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.cleaning_services_rounded, size: 18, color: Color(0xFF10B981)),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DEVICE STORAGE OPTIMIZER',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF34D399),
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        '${reclaimableGb.toStringAsFixed(1)} GB Ready to Free Up',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                ),
                child: const Text(
                  'Safe to Clear',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6EE7B7)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Text(
            '$reclaimableItemCount heavy 4K videos are backed up in your Private Cloud Vault. Clear device copies without losing instant streaming access.',
            style: const TextStyle(fontSize: 12, color: Color(0xFFCBD5E1), height: 1.4),
          ),
          const SizedBox(height: 14),

          // Segmented Progress Bar
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF030712).withOpacity(0.6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1F2937)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Internal Phone Storage', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    Text(
                      '${usedStorageGb.toStringAsFixed(1)} / ${totalStorageGb.toInt()} GB',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF34D399)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 10,
                    child: Row(
                      children: [
                        Flexible(flex: (systemPercent * 100).toInt(), child: Container(color: const Color(0xFF64748B))),
                        Flexible(flex: (otherMediaPercent * 100).toInt(), child: Container(color: const Color(0xFF6366F1))),
                        Flexible(flex: (reclaimPercent * 100).toInt(), child: Container(color: const Color(0xFF10B981))),
                        Flexible(flex: (freePercent * 100).toInt(), child: Container(color: const Color(0xFF334155))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _LegendItem(color: Color(0xFF64748B), label: 'Apps'),
                    _LegendItem(color: Color(0xFF6366F1), label: 'Photos'),
                    _LegendItem(color: Color(0xFF10B981), label: 'Reclaimable', isHighlighted: true),
                    _LegendItem(color: Color(0xFF334155), label: 'Free'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Reclaim Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onFreeUpPressed,
              icon: const Icon(Icons.delete_sweep_rounded, size: 18, color: Color(0xFF030712)),
              label: Text(
                'Free Up ${reclaimableGb.toStringAsFixed(1)} GB Space',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF030712)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                elevation: 4,
                shadowColor: const Color(0xFF10B981).withOpacity(0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isHighlighted;

  const _LegendItem({required this.color, required this.label, this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isHighlighted ? const Color(0xFF6EE7B7) : const Color(0xFF94A3B8),
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

