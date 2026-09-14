import 'package:flutter/material.dart';

class FreeUpSpaceDialog extends StatefulWidget {
  final double reclaimableGb;
  final int itemCount;
  final Future<void> Function() onConfirm;

  const FreeUpSpaceDialog({
    super.key,
    required this.reclaimableGb,
    required this.itemCount,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required double reclaimableGb,
    required int itemCount,
    required Future<void> Function() onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FreeUpSpaceDialog(
        reclaimableGb: reclaimableGb,
        itemCount: itemCount,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<FreeUpSpaceDialog> createState() => _FreeUpSpaceDialogState();
}

class _FreeUpSpaceDialogState extends State<FreeUpSpaceDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: Color(0xFF374151))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFF4B5563),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 18),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.delete_sweep_rounded, color: Color(0xFF10B981), size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Free Up Phone Storage',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    '${widget.itemCount} items ready to clear locally',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Information box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0F19),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1F2937)),
            ),
            child: Column(
              children: [
                _buildInfoRow('Reclaimable Local Space', '${widget.reclaimableGb.toStringAsFixed(1)} GB', const Color(0xFF34D399)),
                const Divider(color: Color(0xFF1F2937), height: 16),
                _buildInfoRow('Cloud Vault Integrity', '100% Backed Up', const Color(0xFF60A5FA)),
                const Divider(color: Color(0xFF1F2937), height: 16),
                const Text(
                  '• High-res streaming proxies remain in your gallery.\n'
                  '• Videos remain playable instantly from your private vault.\n'
                  '• Full original files can be re-downloaded at any time.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() => _isLoading = true);
                      await widget.onConfirm();
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
                    )
                  : Text(
                      'Delete Originals & Free ${widget.reclaimableGb.toStringAsFixed(1)} GB',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Non-destructive. Only verified vaulted items are removed from device.',
            style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFFCBD5E1))),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }
}

